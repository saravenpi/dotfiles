local core =
  dofile(debug.getinfo(1, 'S').source:sub(2):match('(.*/)') .. 'core.lua')

local getwinforfile = function(file)
  for win in vis:windows() do
    if win and win.file and win.file.path == file.path then
      return win
    end
  end
end

local apply = function(win)
  if not win.file.path then
    return
  end
  local ok, ret = pcall(core.get_pairs_for, win.file.path)
  if not ok then
    vis:message(tostring(ret))
  end
  local settings = ret
  local indent_style = (settings.indent_style or ''):lower()
  if indent_style == 'tab' then
    win.options.expandtab = false
    win.options.tabwidth = settings.tab_width
      or (settings.indent_size ~= 'tab' and settings.indent_size)
      or win.options.tabwidth
  elseif indent_style == 'space' then
    win.options.expandtab = true
    win.options.tabwidth = (
      settings.indent_size == 'tab'
        and (settings.tab_width or win.options.tabwidth)
      or settings.indent_size
      or win.options.tabwidth
    )
  end
  if settings.max_line_length and tonumber(settings.max_line_length) then
    win.options.colorcolumn = math.floor(settings.max_line_length + 1)
  end
end

vis.events.subscribe(vis.events.FILE_OPEN, function(file)
  local win = getwinforfile(file)
  if not file.path or not win then
    return
  end
  apply(win)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  if not win.file.path then
    return
  end
  apply(win)
end)
