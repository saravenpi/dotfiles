local M = {}

-- Cache for markdown files to avoid repeated filesystem searches
local file_cache = {}
local cache_valid = false

-- Navigation history
local navigation_history = {}
local current_history_index = 0
local is_navigating_history = false

-- Function to build file cache
local function build_file_cache()
    file_cache = {}
    -- Use git root if available, otherwise fall back to cwd
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
    local cwd = (vim.v.shell_error == 0 and git_root ~= "") and git_root or vim.fn.getcwd()
    
    -- Limit search depth and add reasonable limits to prevent scanning entire filesystem
    local md_files = vim.fs.find(function(name)
        return name:match("%.md$")
    end, {
        path = cwd,
        type = "file",
        limit = 1000, -- Reasonable limit instead of math.huge
        upward = false -- Don't search parent directories
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

-- Function to invalidate graph caches
local function invalidate_graph_caches()
    -- Clear all caches
    graph_cache = {}
    link_cache = {}
    cache_valid = false
    graph_cache_timestamp = 0
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

-- Add current file to history (called before navigating away)
local function add_current_to_history()
    if is_navigating_history then
        return -- Don't add to history when we're navigating through it
    end
    
    local current_file = vim.api.nvim_buf_get_name(0)
    if not current_file or current_file == "" or not current_file:match("%.md$") then
        return
    end
    
    -- If we're in the middle of history stack and navigating to a new file,
    -- truncate the history after current position
    if current_history_index > 0 and current_history_index < #navigation_history then
        for i = #navigation_history, current_history_index + 1, -1 do
            navigation_history[i] = nil
        end
    end
    
    -- Don't add if it's the same as the last entry
    if #navigation_history > 0 and navigation_history[#navigation_history] == current_file then
        return
    end
    
    -- Add current file to history
    table.insert(navigation_history, current_file)
    current_history_index = #navigation_history
end

local function go_back_in_history()
    if #navigation_history == 0 then
        vim.notify("No navigation history available", vim.log.levels.INFO)
        return
    end
    
    if current_history_index <= 1 then
        vim.notify("Already at the beginning of navigation history", vim.log.levels.INFO)
        return
    end
    
    current_history_index = current_history_index - 1
    local file_path = navigation_history[current_history_index]
    
    if file_path and vim.fn.filereadable(file_path) == 1 then
        is_navigating_history = true
        vim.cmd("edit " .. vim.fn.fnameescape(file_path))
        -- Reset flag after a short delay
        vim.defer_fn(function() is_navigating_history = false end, 100)
    else
        vim.notify("File no longer exists: " .. (file_path or "unknown"), vim.log.levels.WARN)
    end
end

local function go_forward_in_history()
    if current_history_index >= #navigation_history then
        vim.notify("Already at the end of navigation history", vim.log.levels.INFO)
        return
    end
    
    current_history_index = current_history_index + 1
    local file_path = navigation_history[current_history_index]
    
    if file_path and vim.fn.filereadable(file_path) == 1 then
        is_navigating_history = true
        vim.cmd("edit " .. vim.fn.fnameescape(file_path))
        -- Reset flag after a short delay
        vim.defer_fn(function() is_navigating_history = false end, 100)
    else
        vim.notify("File no longer exists: " .. (file_path or "unknown"), vim.log.levels.WARN)
    end
end

-- Function to open a link
local function open_link(link, link_type)
    if link_type == "obsidian" then
        -- For obsidian links, search for markdown file
        local file_path = find_markdown_file(link)
        if file_path then
            add_current_to_history() -- Add current file to history before navigating
            vim.cmd("edit " .. vim.fn.fnameescape(file_path))
        else
            -- Create file in same directory as current buffer
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
            local new_file_path = current_dir .. "/" .. link .. ".md"
            
            -- Create file with initial content
            local initial_content = {"# " .. link, "", ""}
            vim.fn.writefile(initial_content, new_file_path)
            
            -- Navigate to the new file
            add_current_to_history()
            vim.cmd("edit " .. vim.fn.fnameescape(new_file_path))
            vim.notify("Created file: " .. link .. ".md", vim.log.levels.INFO)
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
                add_current_to_history() -- Add current file to history before navigating
                vim.cmd("edit " .. vim.fn.fnameescape(file_path))
            else
                -- Create file in same directory as current buffer
                local current_file = vim.api.nvim_buf_get_name(0)
                local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
                local filename = link:gsub("%.md$", "") -- Remove .md if present
                local new_file_path = current_dir .. "/" .. filename .. ".md"
                
                -- Create file with initial content
                local initial_content = {"# " .. filename, "", ""}
                vim.fn.writefile(initial_content, new_file_path)
                
                -- Navigate to the new file
                add_current_to_history()
                vim.cmd("edit " .. vim.fn.fnameescape(new_file_path))
                vim.notify("Created file: " .. filename .. ".md", vim.log.levels.INFO)
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

-- Function to find all markdown links in current buffer
local function find_all_links()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local links = {}
    
    for line_num, line in ipairs(lines) do
        -- Find obsidian-style links [[]]
        for start_pos, end_pos in line:gmatch("()%[%[[^%]]*%]%]()") do
            table.insert(links, {
                line = line_num,
                col = start_pos,
                end_col = end_pos - 1,
                type = "obsidian"
            })
        end
        
        -- Find markdown links []()
        for start_pos, end_pos in line:gmatch("()%[[^%]]*%]%([^%)]*%)()") do
            table.insert(links, {
                line = line_num,
                col = start_pos,
                end_col = end_pos - 1,
                type = "markdown"
            })
        end
    end
    
    return links
end

-- Function to navigate to next markdown link
function M.next_link()
    local links = find_all_links()
    if #links == 0 then
        return
    end
    
    local current_pos = vim.api.nvim_win_get_cursor(0)
    local current_line = current_pos[1]
    local current_col = current_pos[2] + 1 -- Convert to 1-indexed
    
    -- Find next link after current position
    for _, link in ipairs(links) do
        if link.line > current_line or (link.line == current_line and link.col > current_col) then
            vim.api.nvim_win_set_cursor(0, {link.line, link.col - 1}) -- Convert back to 0-indexed
            return
        end
    end
    
    -- If no link found after current position, wrap to first link
    if #links > 0 then
        vim.api.nvim_win_set_cursor(0, {links[1].line, links[1].col - 1})
    end
end

-- Function to navigate to previous markdown link
function M.prev_link()
    local links = find_all_links()
    if #links == 0 then
        return
    end
    
    local current_pos = vim.api.nvim_win_get_cursor(0)
    local current_line = current_pos[1]
    local current_col = current_pos[2] + 1 -- Convert to 1-indexed
    
    -- Find previous link before current position (search backwards)
    for i = #links, 1, -1 do
        local link = links[i]
        if link.line < current_line or (link.line == current_line and link.col < current_col) then
            vim.api.nvim_win_set_cursor(0, {link.line, link.col - 1}) -- Convert back to 0-indexed
            return
        end
    end
    
    -- If no link found before current position, wrap to last link
    if #links > 0 then
        local last_link = links[#links]
        vim.api.nvim_win_set_cursor(0, {last_link.line, last_link.col - 1})
    end
end

-- Navigation history functions
function M.go_back()
    go_back_in_history()
end

function M.go_forward()
    go_forward_in_history()
end

-- Debug function to show history state
function M.show_history()
    print("Navigation History:")
    print("Current index: " .. current_history_index)
    print("History length: " .. #navigation_history)
    print("Is navigating: " .. tostring(is_navigating_history))
    print("Current file: " .. (vim.api.nvim_buf_get_name(0) or "none"))
    for i, file in ipairs(navigation_history) do
        local marker = (i == current_history_index) and " -> " or "    "
        local filename = file and vim.fn.fnamemodify(file, ":t") or "nil"
        print(marker .. i .. ": " .. filename)
    end
end

-- Debug function to show cache performance stats
function M.show_cache_stats()
    print("=== Markdown Links Cache Statistics ===")
    print("File cache valid: " .. tostring(cache_valid))
    print("File cache entries: " .. vim.tbl_count(file_cache))
    print("Link cache entries: " .. vim.tbl_count(link_cache))
    print("Graph cache entries: " .. vim.tbl_count(graph_cache))
    print("Max files to scan: " .. MAX_FILES_TO_SCAN)
    print("Graph cache TTL: " .. GRAPH_CACHE_TTL .. "ms")
    
    local now = vim.loop.hrtime() / 1000000
    print("\nGraph cache details:")
    for file, cached in pairs(graph_cache) do
        local age = now - cached.timestamp
        local expired = age > GRAPH_CACHE_TTL
        print("  " .. file .. ": " .. math.floor(age) .. "ms old" .. (expired and " (expired)" or " (valid)"))
    end
    
    print("\nLink cache details:")
    for file, cached in pairs(link_cache) do
        print("  " .. vim.fn.fnamemodify(file, ":t") .. ": " .. #cached.links .. " links")
    end
end

-- Function to get visual selection text (improved)
local function get_visual_selection()
    -- Exit visual mode to ensure marks are set
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
    
    -- Get selection bounds
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local start_row, start_col = start_pos[1] - 1, start_pos[2]
    local end_row, end_col = end_pos[1] - 1, end_pos[2]
    
    -- Get selected text
    local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
    
    if #lines == 0 then
        return ""
    end
    
    -- Join lines with space for single-line link names
    return table.concat(lines, " "):gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
end

-- Function to create a link and file, then navigate to it
function M.create_link_and_file()
    local selection = get_visual_selection()
    if selection == "" then
        vim.notify("No text selected", vim.log.levels.WARN)
        return
    end
    
    -- Clean the selection to make a valid filename while preserving casing, spaces, and accents
    -- Remove only truly problematic characters for filenames: / \ : * ? " < > |
    local filename = selection:gsub('[/\\:*?"<>|]', ""):gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
    if filename == "" then
        vim.notify("Selection doesn't contain valid filename characters", vim.log.levels.WARN)
        return
    end
    
    -- Get current file directory
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
    local new_file_path = current_dir .. "/" .. filename .. ".md"
    
    -- Replace selection with obsidian-style link (preserve original text for link display)
    local link_text = "[[" .. filename .. "]]"
    
    -- Get selection bounds (using fresh marks)
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local start_row, start_col = start_pos[1] - 1, start_pos[2]
    local end_row, end_col = end_pos[1] - 1, end_pos[2] + 1
    
    -- Replace the selected text with the link
    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {link_text})
    
    -- Create the new file if it doesn't exist
    if vim.fn.filereadable(new_file_path) == 0 then
        -- Create file with initial content (use original selection for title)
        local initial_content = {"# " .. selection, "", ""}
        vim.fn.writefile(initial_content, new_file_path)
    end
    
    -- Add current file to history and navigate to new file
    add_current_to_history()
    vim.cmd("edit " .. vim.fn.fnameescape(new_file_path))
    
    vim.notify("Created link and file: " .. filename .. ".md", vim.log.levels.INFO)
end

-- Function to create link and file without navigation
function M.create_link_only()
    local selection = get_visual_selection()
    if selection == "" then
        vim.notify("No text selected", vim.log.levels.WARN)
        return
    end
    
    -- Clean the selection to make a valid link name while preserving casing, spaces, and accents
    -- Remove only truly problematic characters for filenames: / \ : * ? " < > |
    local link_name = selection:gsub('[/\\:*?"<>|]', ""):gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
    if link_name == "" then
        vim.notify("Selection doesn't contain valid link characters", vim.log.levels.WARN)
        return
    end
    
    -- Get current file directory
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
    local new_file_path = current_dir .. "/" .. link_name .. ".md"
    
    -- Replace selection with obsidian-style link
    local link_text = "[[" .. link_name .. "]]"
    
    -- Get selection bounds (using fresh marks)
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local start_row, start_col = start_pos[1] - 1, start_pos[2]
    local end_row, end_col = end_pos[1] - 1, end_pos[2] + 1
    
    -- Replace the selected text with the link
    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {link_text})
    
    -- Create the new file if it doesn't exist (but don't navigate to it)
    if vim.fn.filereadable(new_file_path) == 0 then
        -- Create file with initial content (use original selection for title)
        local initial_content = {"# " .. selection, "", ""}
        vim.fn.writefile(initial_content, new_file_path)
        vim.notify("Created link and file: " .. link_name .. ".md", vim.log.levels.INFO)
    else
        vim.notify("Created link: " .. link_text .. " (file already exists)", vim.log.levels.INFO)
    end
end

-- Graph view variables
local graph_buf = nil
local graph_win = nil

-- Graph optimization caches
local graph_cache = {}
local link_cache = {} -- Cache for individual file links
local graph_cache_timestamp = 0
local GRAPH_CACHE_TTL = 5000 -- 5 seconds TTL
local MAX_FILES_TO_SCAN = 200 -- Limit for performance

-- Optimized function to find all links in a file with caching
local function find_links_in_file(file_path)
    if not vim.fn.filereadable(file_path) then
        return {}
    end
    
    -- Check cache first
    local file_stat = vim.loop.fs_stat(file_path)
    if not file_stat then
        return {}
    end
    
    local cache_key = file_path
    local cached_entry = link_cache[cache_key]
    
    -- Use cache if file hasn't been modified
    if cached_entry and cached_entry.mtime >= file_stat.mtime.sec then
        return cached_entry.links
    end
    
    -- Read and parse file
    local links = {}
    local lines = vim.fn.readfile(file_path, '', 100) -- Only read first 100 lines for performance
    
    for _, line in ipairs(lines) do
        -- Find obsidian-style links [[]] - optimized pattern
        local start = 1
        while true do
            local s, e = line:find("%[%[[^%]]+%]%]", start)
            if not s then break end
            local link = line:sub(s + 2, e - 2)
            if link ~= "" then
                table.insert(links, link)
            end
            start = e + 1
        end
        
        -- Find markdown links []() - optimized pattern
        start = 1
        while true do
            local s, e = line:find("%[[^%]]*%]%([^%)]+%)", start)
            if not s then break end
            local paren_start = line:find("%(", s)
            local paren_end = line:find("%)", paren_start)
            if paren_start and paren_end then
                local link = line:sub(paren_start + 1, paren_end - 1)
                -- Only include .md files or files without extension
                if link:match("%.md$") or not link:match("%.") then
                    link = link:gsub("%.md$", "")
                    if link ~= "" then
                        table.insert(links, link)
                    end
                end
            end
            start = e + 1
        end
    end
    
    -- Cache the result
    link_cache[cache_key] = {
        links = links,
        mtime = file_stat.mtime.sec
    }
    
    return links
end

-- Optimized function to build a graph of connections with caching
local function build_link_graph()
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_name = vim.fn.fnamemodify(current_file, ":t:r")
    local now = vim.loop.hrtime() / 1000000 -- Convert to milliseconds
    
    -- Check graph cache first
    local cache_key = current_name
    local cached_graph = graph_cache[cache_key]
    
    if cached_graph and (now - cached_graph.timestamp) < GRAPH_CACHE_TTL then
        return cached_graph.graph, current_name
    end
    
    -- Build file cache if needed
    if not cache_valid then
        build_file_cache()
    end
    
    local graph = {}
    
    -- Start with current file
    graph[current_name] = {
        file_path = current_file,
        outgoing = {},
        incoming = {},
        level = 0
    }
    
    -- Find outgoing links from current file (always fresh)
    local outgoing_links = find_links_in_file(current_file)
    local outgoing_set = {}
    
    for _, link in ipairs(outgoing_links) do
        if not outgoing_set[link] then -- Deduplicate
            outgoing_set[link] = true
            graph[current_name].outgoing[link] = true
            
            -- Add linked files to graph
            if not graph[link] then
                local file_path = find_markdown_file(link)
                graph[link] = {
                    file_path = file_path,
                    outgoing = {},
                    incoming = {},
                    level = 1
                }
            end
            graph[link].incoming[current_name] = true
        end
    end
    
    -- Find incoming links (files that link to current file)
    -- Limit scanning for performance
    local files_scanned = 0
    for filename, file_paths in pairs(file_cache) do
        if files_scanned >= MAX_FILES_TO_SCAN then
            break
        end
        
        if filename ~= current_name then
            files_scanned = files_scanned + 1
            local file_path = file_paths[1]
            local links = find_links_in_file(file_path)
            
            for _, link in ipairs(links) do
                if link == current_name then
                    -- This file links to current file
                    if not graph[filename] then
                        graph[filename] = {
                            file_path = file_path,
                            outgoing = {},
                            incoming = {},
                            level = -1
                        }
                    end
                    graph[filename].outgoing[current_name] = true
                    graph[current_name].incoming[filename] = true
                    break -- Found link to current file, no need to continue
                end
            end
        end
    end
    
    -- Cache the result
    graph_cache[cache_key] = {
        graph = graph,
        timestamp = now
    }
    
    -- Clean old cache entries to prevent memory leaks
    for key, cached in pairs(graph_cache) do
        if (now - cached.timestamp) > (GRAPH_CACHE_TTL * 2) then
            graph_cache[key] = nil
        end
    end
    
    return graph, current_name
end

-- Clean borderless graph visualization with interactive features
local function create_graph_text(graph, current_name)
    local lines = {}
    local processed = {}
    local interactive_lines = {} -- Track which lines are interactive
    
    -- Helper function to add line and track interactivity
    local function add_line(content, is_interactive, filename)
        lines[#lines + 1] = content
        interactive_lines[#lines] = {
            interactive = is_interactive or false,
            filename = filename
        }
    end
    
    -- Pre-calculate all collections for better performance
    local incoming_files = {}
    local outgoing_files = {}
    local orphaned = {}
    
    -- Collect incoming files
    for file, _ in pairs(graph[current_name].incoming) do
        table.insert(incoming_files, file)
    end
    table.sort(incoming_files) -- Sort for consistent display
    
    -- Collect outgoing files
    for file, _ in pairs(graph[current_name].outgoing) do
        table.insert(outgoing_files, file)
    end
    table.sort(outgoing_files) -- Sort for consistent display
    
    -- Mark processed files
    for _, file in ipairs(incoming_files) do
        processed[file] = true
    end
    for _, file in ipairs(outgoing_files) do
        processed[file] = true
    end
    
    -- Collect orphaned files
    for file, _ in pairs(graph) do
        if not processed[file] and file ~= current_name then
            table.insert(orphaned, file)
        end
    end
    table.sort(orphaned)
    
    -- Build clean borderless layout
    add_line("Markdown Link Graph", false)
    add_line("", false)
    
    -- Show incoming links
    if #incoming_files > 0 then
        add_line("◄── Incoming Links:", false)
        for _, file in ipairs(incoming_files) do
            add_line("  ➤ " .. file, true, file)
        end
        add_line("", false)
    end
    
    -- Show current file
    local current_display = "● " .. current_name .. " (current)"
    add_line(current_display, false)
    add_line("", false)
    
    -- Show outgoing links
    if #outgoing_files > 0 then
        add_line("──► Outgoing Links:", false)
        for _, file in ipairs(outgoing_files) do
            local exists = graph[file] and graph[file].file_path and vim.fn.filereadable(graph[file].file_path) == 1
            local marker = exists and "➤ " or "✗ "
            local interactive = exists -- Only make existing files interactive
            add_line("  " .. marker .. file, interactive, exists and file or nil)
        end
        add_line("", false)
    end
    
    -- Show orphaned files (limit to 5 for performance)
    if #orphaned > 0 then
        add_line("○ Other Connected Files:", false)
        local orphaned_limit = math.min(#orphaned, 5)
        for i = 1, orphaned_limit do
            local file = orphaned[i]
            local exists = graph[file] and graph[file].file_path and vim.fn.filereadable(graph[file].file_path) == 1
            local marker = exists and "➤ " or "○ "
            add_line("  " .. marker .. file, exists, exists and file or nil)
        end
        if #orphaned > 5 then
            local more_count = #orphaned - 5
            add_line("  ... and " .. more_count .. " more", false)
        end
        add_line("", false)
    end
    
    -- Summary stats
    local total_files = 0
    for _ in pairs(graph) do total_files = total_files + 1 end
    
    add_line("Total files: " .. total_files .. " │ Outgoing: " .. #outgoing_files .. " │ Incoming: " .. #incoming_files, false)
    add_line("", false)
    add_line("↑/↓: Navigate │ Enter: Open │ q: Close", false)
    
    return lines, interactive_lines
end

-- Function to set up clean syntax highlighting for borderless graph
local function setup_graph_syntax(buf)
    vim.api.nvim_buf_call(buf, function()
        -- Clear existing syntax
        vim.cmd('syntax clear')
        
        -- Define syntax groups for clean borderless design
        vim.cmd('syntax match GraphTitle /^Markdown Link Graph$/')
        vim.cmd('syntax match GraphCurrent /^● .* (current)$/')
        
        -- Interactive filenames only (after ➤ marker)
        vim.cmd('syntax match GraphInteractiveMarker /➤/ contained')
        vim.cmd('syntax match GraphInteractiveFile /\\(➤ \\)\\@<=.*$/ contained')
        vim.cmd('syntax match GraphInteractiveLine /^  ➤ .*$/ contains=GraphInteractiveMarker,GraphInteractiveFile')
        
        -- Missing files (after ✗ marker)  
        vim.cmd('syntax match GraphMissingMarker /✗/ contained')
        vim.cmd('syntax match GraphMissingFile /\\(✗ \\)\\@<=.*$/ contained')
        vim.cmd('syntax match GraphMissingLine /^  ✗ .*$/ contains=GraphMissingMarker,GraphMissingFile')
        
        -- Section headers
        vim.cmd('syntax match GraphSection /^◄──.*:\\|^──►.*:\\|^○.*:/')
        
        -- Stats and help
        vim.cmd('syntax match GraphStats /^Total files.*/')
        vim.cmd('syntax match GraphHelp /^↑\\/↓.*/')
        
        -- Define clean highlight groups
        vim.cmd('highlight GraphTitle guifg=#b4befe ctermfg=147 gui=bold')
        vim.cmd('highlight GraphCurrent guifg=#f9e2af ctermfg=221 gui=bold')
        
        -- Interactive elements
        vim.cmd('highlight GraphInteractiveMarker guifg=#a6e3a1 ctermfg=151 gui=bold')
        vim.cmd('highlight GraphInteractiveFile guifg=#a6e3a1 ctermfg=151')
        
        -- Missing files
        vim.cmd('highlight GraphMissingMarker guifg=#f38ba8 ctermfg=210 gui=bold')
        vim.cmd('highlight GraphMissingFile guifg=#f38ba8 ctermfg=210')
        
        -- Other elements
        vim.cmd('highlight GraphSection guifg=#89b4fa ctermfg=117 gui=bold')
        vim.cmd('highlight GraphStats guifg=#cdd6f4 ctermfg=189')
        vim.cmd('highlight GraphHelp guifg=#6c7086 ctermfg=245 gui=italic')
    end)
end

-- Function to find next/previous interactive line
local function find_interactive_line(interactive_lines, current_line, direction)
    local lines = {}
    for line_num, data in pairs(interactive_lines) do
        if data.interactive then
            table.insert(lines, line_num)
        end
    end
    
    if #lines == 0 then
        return current_line
    end
    
    table.sort(lines)
    
    -- Find current position in interactive lines
    local current_idx = 1
    for i, line_num in ipairs(lines) do
        if line_num >= current_line then
            current_idx = i
            break
        end
    end
    
    if direction > 0 then
        -- Next
        current_idx = current_idx + 1
        if current_idx > #lines then
            current_idx = 1 -- Wrap to first
        end
    else
        -- Previous
        current_idx = current_idx - 1
        if current_idx < 1 then
            current_idx = #lines -- Wrap to last
        end
    end
    
    return lines[current_idx]
end

-- Function to toggle graph view with interactive features
function M.toggle_graph()
    -- If graph is open, close it
    if graph_win and vim.api.nvim_win_is_valid(graph_win) then
        vim.api.nvim_win_close(graph_win, true)
        if graph_buf and vim.api.nvim_buf_is_valid(graph_buf) then
            vim.api.nvim_buf_delete(graph_buf, { force = true })
        end
        graph_win = nil
        graph_buf = nil
        return
    end
    
    -- Build the graph
    local graph, current_name = build_link_graph()
    local graph_lines, interactive_lines = create_graph_text(graph, current_name)
    
    -- Create buffer
    graph_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(graph_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(graph_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(graph_buf, 'filetype', 'markdown-graph')
    vim.api.nvim_buf_set_option(graph_buf, 'modifiable', false)
    
    -- Set content
    vim.api.nvim_buf_set_option(graph_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(graph_buf, 0, -1, false, graph_lines)
    vim.api.nvim_buf_set_option(graph_buf, 'modifiable', false)
    
    -- Set up syntax highlighting
    setup_graph_syntax(graph_buf)
    
    -- Create window (bottom split)
    local height = math.min(#graph_lines + 2, math.floor(vim.o.lines * 0.4))
    vim.cmd('botright ' .. height .. 'split')
    graph_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(graph_win, graph_buf)
    
    -- Window options
    vim.api.nvim_win_set_option(graph_win, 'wrap', false)
    vim.api.nvim_win_set_option(graph_win, 'cursorline', true)
    vim.api.nvim_win_set_option(graph_win, 'number', false)
    vim.api.nvim_win_set_option(graph_win, 'relativenumber', false)
    vim.api.nvim_win_set_option(graph_win, 'signcolumn', 'no')
    vim.api.nvim_win_set_option(graph_win, 'cursorlineopt', 'both')
    
    -- Buffer-local keymaps
    local opts = { buffer = graph_buf, nowait = true, silent = true }
    
    -- Close graph
    vim.keymap.set('n', 'q', M.toggle_graph, opts)
    vim.keymap.set('n', '<ESC>', M.toggle_graph, opts)
    vim.keymap.set('n', '<leader>mg', M.toggle_graph, opts)
    
    -- Smart navigation - only move between interactive lines
    vim.keymap.set('n', 'j', function()
        local current_line = vim.api.nvim_win_get_cursor(graph_win)[1]
        local next_line = find_interactive_line(interactive_lines, current_line, 1)
        vim.api.nvim_win_set_cursor(graph_win, {next_line, 0})
    end, opts)
    
    vim.keymap.set('n', 'k', function()
        local current_line = vim.api.nvim_win_get_cursor(graph_win)[1]
        local prev_line = find_interactive_line(interactive_lines, current_line, -1)
        vim.api.nvim_win_set_cursor(graph_win, {prev_line, 0})
    end, opts)
    
    vim.keymap.set('n', '<Down>', function()
        local current_line = vim.api.nvim_win_get_cursor(graph_win)[1]
        local next_line = find_interactive_line(interactive_lines, current_line, 1)
        vim.api.nvim_win_set_cursor(graph_win, {next_line, 0})
    end, opts)
    
    vim.keymap.set('n', '<Up>', function()
        local current_line = vim.api.nvim_win_get_cursor(graph_win)[1]
        local prev_line = find_interactive_line(interactive_lines, current_line, -1)
        vim.api.nvim_win_set_cursor(graph_win, {prev_line, 0})
    end, opts)
    
    -- Navigate to files on Enter
    vim.keymap.set('n', '<CR>', function()
        local current_line = vim.api.nvim_win_get_cursor(graph_win)[1]
        local line_data = interactive_lines[current_line]
        
        if line_data and line_data.interactive and line_data.filename then
            -- Close graph
            M.toggle_graph()
            -- Navigate to file
            local file_path = find_markdown_file(line_data.filename)
            if file_path then
                add_current_to_history()
                vim.cmd("edit " .. vim.fn.fnameescape(file_path))
            else
                vim.notify("File not found: " .. line_data.filename, vim.log.levels.WARN)
            end
        end
    end, opts)
    
    -- Move cursor to first interactive line
    vim.cmd('normal! gg')
    local first_interactive = find_interactive_line(interactive_lines, 1, 1)
    if first_interactive then
        vim.api.nvim_win_set_cursor(graph_win, {first_interactive, 0})
    end
end

-- Setup function to create the keymap
function M.setup()
    -- Don't build cache on startup - defer until first use
    
    -- Watch for file changes to invalidate cache
    vim.api.nvim_create_autocmd({"BufWritePost", "BufNewFile", "BufDelete"}, {
        pattern = "*.md",
        callback = invalidate_graph_caches -- Use improved cache invalidation
    })
    
    -- Track when markdown files are opened by other means (e.g., mini.pick)
    -- We'll use BufReadPost which fires after the file is actually loaded
    vim.api.nvim_create_autocmd({"BufReadPost"}, {
        pattern = "*.md",
        callback = function()
            if is_navigating_history then
                return -- Don't interfere with history navigation
            end
            
            -- This handles the case where user opens a file via mini.pick or other means
            -- We add it to history so they can navigate back
            vim.defer_fn(function()
                add_current_to_history()
            end, 50)
        end
    })
    
    -- Create autocommand for markdown files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.keymap.set("n", "<CR>", M.follow_link, {
                buffer = true,
                desc = "Follow markdown link"
            })
            vim.keymap.set("n", "<Tab>", M.next_link, {
                buffer = true,
                desc = "Next markdown link"
            })
            vim.keymap.set("n", "<S-Tab>", M.prev_link, {
                buffer = true,
                desc = "Previous markdown link"
            })
            vim.keymap.set("n", "<leader>mb", M.go_back, {
                buffer = true,
                desc = "Go back in markdown navigation history"
            })
            vim.keymap.set("n", "<leader>mf", M.go_forward, {
                buffer = true,
                desc = "Go forward in markdown navigation history"
            })
            vim.keymap.set("n", "<leader>mh", M.show_history, {
                buffer = true,
                desc = "Show markdown navigation history (debug)"
            })
            vim.keymap.set("v", "<leader>mc", M.create_link_and_file, {
                buffer = true,
                desc = "Create link and file from selection"
            })
            vim.keymap.set("v", "<leader>ml", M.create_link_only, {
                buffer = true,
                desc = "Create link from selection (no file)"
            })
            vim.keymap.set("n", "<leader>mg", M.toggle_graph, {
                buffer = true,
                desc = "Toggle markdown link graph"
            })
            vim.keymap.set("n", "<leader>ms", M.show_cache_stats, {
                buffer = true,
                desc = "Show markdown cache statistics"
            })
        end
    })
end

return M