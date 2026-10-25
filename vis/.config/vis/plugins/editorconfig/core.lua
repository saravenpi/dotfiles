local from_cmd = function(cmd)
  local fz = io.popen(cmd)
  if fz then
    local out = fz:read('*a')
    local _, _, status = fz:close()
    if status == 0 then
      return out
    end
  end
end

local parse_kp = function(line)
  local i, j = line:find('%s*=%s*')
  local key = line:sub(1, i - 1):gsub('^%s*', '')
  local val = line:sub(j + 1, line:len()):gsub('%s*$', '')
  return key, val
end

local section_to_pattern = function(selector)
  local i, token, literal = 0, nil, nil
  local nexttoken = function(str, index, in_options)
    local c = str:sub(index, index)
    if c == '*' then
      local len = str:sub(index):match('^%**'):len()
      if len > 1 then
        return index + len, 'all'
      else
        return index + 1, 'noslash'
      end
    elseif c == '[' then
      local finish = str:find(']', index + 2)
      if str:sub(index + 1, index + 1) ~= '!' then
        return finish + 1, 'chars', str:sub(index + 1, finish - 1)
      else
        return finish + 1, 'no_chars', str:sub(index + 2, finish - 1)
      end
    elseif c == '?' then
      return index + 1, 'any'
    elseif in_options and c == ',' then
      return index + 1, 'nextoption'
    elseif in_options and c == '}' then
      return index + 1, 'endoptions'
    elseif c == '{' then
      local lower, upper = str:sub(index):match('^{([0-9]+)..([0-9]+)}')
      if lower and upper then
        return 5 + lower:len() + upper:len(), 'number', upper
      else
        return index + 1, 'options'
      end
    elseif c == '\\' then
      return index + 2, 'literal', str:sub(index + 1, index + 1)
    else
      return index + 1, 'literal', c
    end
  end
  local append = function(prefix, suffix)
    if #prefix == 0 then prefix[1] = '' end
    if type(suffix) == 'string' then
      suffix = { suffix }
    end
    local newtable = {}
    for _, a in ipairs(prefix) do
      for _, b in ipairs(suffix) do
        table.insert(newtable, a .. b)
      end
    end
    return newtable
  end
  local function translate(in_options)
    local r = {}
    while i <= #selector do
      i, token, literal = nexttoken(selector, i, in_options)
      if token == 'noslash' then
        r = append(r, '[^/]+')
      elseif token == 'all' then
        r = append(r, '.+')
      elseif token == 'any' then
        r = append(r, '.')
      elseif token == 'chars' then
        r = append(r, '[' .. literal .. ']')
      elseif token == 'no_chars' then
        r = append(r, '[^' .. literal .. ']')
      elseif token == 'number' then
        r = append(r, '%d+')
      elseif token == 'nextoption' or token == 'endoptions' then
        return r
      elseif token == 'options' then
        local temp = {}
        while token ~= 'endoptions' do
          for _, newPattern in ipairs(translate(true)) do
            table.insert(temp, newPattern)
          end
        end
        r = append(r, temp)
      elseif token == 'literal' then
        r = append(
          r,
          (literal or ''):gsub('[^%w]', function(c)
            return '%' .. c
          end)
        )
      else
      end
    end
    return r
  end
  local patterns = translate(false)
  return function(path)
    for _, pattern in ipairs(patterns) do
      if path:match(pattern) then
        return true
      end
    end
  end
end

local parse_file = function(path)
  local config = {}
  for line in io.open(path):lines() do
    if line:match('^%s*[^[;#][^=]*=') then -- key-value pair
      local key, val = parse_kp(line)
      if #config == 0 then
        if key == 'root' then
          config.root = val == 'true'
        else
          error(
            'Warning: '
              .. path
              .. ' has a property outside a section: '
              .. line,
            0
          )
        end
      else
        config[#config].pairs[key] = val
      end
    elseif line:match('^%s*%[.*%]%s*$') then -- section
      config[#config + 1] = {
        ['pairs'] = {},
        match = section_to_pattern(line:gsub('^%s*%[', ''):gsub('%]%s*$', '')),
      }
    elseif not line:match('^%s*$') and not line:match('^%s*[#;]') then
      print(path .. ': invalid line: ' .. line)
    end
  end
  for i = 1, math.floor(#config / 2), 1 do
    config[i], config[#config - i + 1] = config[#config - i + 1], config[i]
  end
  return config
end

local get_config_files = function(path)
  local config_files =
    from_cmd("set -- '" .. path:gsub("'", "'\\''") .. "'; " .. [[
      while [ "$1" != / ]; do
        cd "$(dirname "$1")"
        set -- "$PWD"
        ! [ -e .editorconfig ] || printf "%s/.editorconfig\0" "$1"
      done
    ]])
  return string.gmatch(config_files, '%Z+')
end

local configs = {}
local get_configs_for = function(path)
  local specific_configs = {}
  for path in get_config_files(path) do
    if configs[path] == nil then
      configs[path] = parse_file(path)
    end
    table.insert(specific_configs, configs[path])
  end
  return specific_configs
end

local get_sections_for = function(configs, path)
  local sections = {}
  for _, config in pairs(configs) do
    for _, section in ipairs(config) do
      if section.match(path) then
        table.insert(sections, section)
      end
    end
    if config.root then
      break
    end
  end
  return sections
end

local get_pairs = function(sections)
  local all_pairs = {}
  for _, section in ipairs(sections) do
    for key, val in pairs(section.pairs) do
      if all_pairs[key] == nil then
        all_pairs[key] = val ~= 'unset' and val or nil
      end
    end
  end
  return all_pairs
end

return {
  section_to_pattern = section_to_pattern,
  get_pairs_for = function(path)
    return get_pairs(get_sections_for(get_configs_for(path), path))
  end,
}
