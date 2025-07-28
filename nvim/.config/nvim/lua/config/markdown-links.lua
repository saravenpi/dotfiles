local M = {}

-- Cache for markdown files to avoid repeated filesystem searches
local file_cache = {}
local cache_valid = false

-- Function to build file cache
local function build_file_cache()
    file_cache = {}
    local cwd = vim.fn.getcwd()
    
    -- Use vim.fs.find for faster file discovery
    local md_files = vim.fs.find(function(name)
        return name:match("%.md$")
    end, {
        path = cwd,
        type = "file",
        limit = math.huge
    })
    
    -- Build lookup table: filename without extension -> full path
    for _, file_path in ipairs(md_files) do
        local filename = vim.fn.fnamemodify(file_path, ":t:r") -- get filename without extension
        if not file_cache[filename] then
            file_cache[filename] = {}
        end
        table.insert(file_cache[filename], file_path)
    end
    
    cache_valid = true
end

-- Function to invalidate cache when files change
local function invalidate_cache()
    cache_valid = false
end

-- Function to get the link under cursor
local function get_link_under_cursor()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    
    -- Check for [[]] obsidian-style links
    local obsidian_start, obsidian_end = line:find("%[%[[^%]]*%]%]")
    if obsidian_start and obsidian_end and col >= obsidian_start and col <= obsidian_end then
        local link_text = line:sub(obsidian_start + 2, obsidian_end - 2)
        return link_text, "obsidian"
    end
    
    -- Check for []() markdown links
    local md_start, md_end = line:find("%[[^%]]*%]%([^%)]*%)")
    if md_start and md_end and col >= md_start and col <= md_end then
        local paren_start = line:find("%(", md_start)
        local paren_end = line:find("%)", paren_start)
        if paren_start and paren_end then
            local link_url = line:sub(paren_start + 1, paren_end - 1)
            return link_url, "markdown"
        end
    end
    
    return nil, nil
end

-- Function to find markdown files matching the link
local function find_markdown_file(filename)
    if not filename or filename == "" then
        return nil
    end
    
    -- Ensure cache is built
    if not cache_valid then
        build_file_cache()
    end
    
    -- Remove .md extension if present for lookup
    local search_name = filename:gsub("%.md$", "")
    
    -- Fast lookup in cache
    local matches = file_cache[search_name]
    if matches and #matches > 0 then
        return matches[1] -- Return first match
    end
    
    return nil
end

-- Function to open a link
local function open_link(link, link_type)
    if link_type == "obsidian" then
        -- For obsidian links, search for markdown file
        local file_path = find_markdown_file(link)
        if file_path then
            vim.cmd("edit " .. vim.fn.fnameescape(file_path))
        else
            vim.notify("File not found: " .. link .. ".md", vim.log.levels.WARN)
        end
    elseif link_type == "markdown" then
        -- For markdown links, check if it's a local file or URL
        if link:match("^https?://") then
            -- Open URL in browser
            vim.fn.system("open " .. vim.fn.shellescape(link))
        else
            -- Try to open as local file
            local file_path = link
            if not vim.fn.filereadable(file_path) then
                -- Try with .md extension
                file_path = find_markdown_file(link)
            end
            
            if file_path and vim.fn.filereadable(file_path) then
                vim.cmd("edit " .. vim.fn.fnameescape(file_path))
            else
                vim.notify("File not found: " .. link, vim.log.levels.WARN)
            end
        end
    end
end

-- Main function to handle link navigation
function M.follow_link()
    local link, link_type = get_link_under_cursor()
    if link and link_type then
        open_link(link, link_type)
    else
        -- Fallback to default Enter behavior
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    end
end

-- Setup function to create the keymap
function M.setup()
    -- Build initial cache
    build_file_cache()
    
    -- Watch for file changes to invalidate cache
    vim.api.nvim_create_autocmd({"BufWritePost", "BufNewFile", "BufDelete"}, {
        pattern = "*.md",
        callback = invalidate_cache
    })
    
    -- Create autocommand for markdown files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.keymap.set("n", "<CR>", M.follow_link, {
                buffer = true,
                desc = "Follow markdown link"
            })
        end
    })
end

return M