-- Copyright (c) 2023-2024 Florian Fischer. All rights reserved.
--
-- vis-inotify is free software: you can redistribute it and/or modify it under
-- the terms of the GNU General Public License as published by the Free Software
-- Foundation, either version 3 of the License, or (at your option) any later
-- version.
--
-- vis-inotify is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along with
-- vis-inotify found in the LICENSE file.
-- If not, see <https://www.gnu.org/licenses/>.
if not vis.communicate then
    vis:info('Error: vis-inotify requires vis communicate patch')
    return {}
end

if not os.execute('type inotifywait >/dev/null 2>/dev/null') then
    -- inotifywait optional
    return {}
end

-- vis is exiting to not recreate watches
local exiting = false

-- We have to keep the handles to our communicate processes otherwise
-- vis will terminate them.
local watches = {} -- luacheck: ignore watches
local function _add_watch(file, func, mode, cmd_options)
    local cmd = 'exec inotifywait '
    if cmd_options then cmd = cmd .. ' ' .. cmd_options .. ' ' end

    if mode == 'monitor' then cmd = cmd .. '-m ' end
    cmd = cmd .. file

    local watch_fd = vis:communicate(file, cmd)
    watches[file] = watch_fd

    vis.events.subscribe(vis.events.PROCESS_RESPONSE,
                         function(name, event, code, msg)
        if name ~= file then return end

        if event == 'EXIT' or event == 'SIGNAL' then
            if event == 'EXIT' then
                if mode == 'recreate' and not exiting then
                    -- recreate the watch
                    watches[file] = nil
                    watches[file] = vis:communicate(file, cmd)
                else
                    vis:info(file .. ' watch exited with: ' .. code)
                end
            else
                vis:info(file .. ' watch received signal: ' .. code)
            end
            return
        end

        if event == 'STDOUT' then func(msg) end
    end)
end

local M = {}
M.add_monitor_watch = function(file, func, cmd_options)
    _add_watch(file, func, 'monitor', cmd_options)
end

M.add_single_shot_watch = function(file, func, cmd_options)
    _add_watch(file, func, 'single_shot', cmd_options)
end

M.add_recreate_watch = function(file, func, cmd_options)
    _add_watch(file, func, 'recreate', cmd_options)
end

vis.events.subscribe(vis.events.QUIT, function()
    exiting = true
    -- Terminate all watches
    for k, _ in pairs(watches) do watches[k] = nil end
end)

return M
