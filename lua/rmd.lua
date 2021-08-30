local M = {}

function M.run_block()
    local stdin = vim.loop.new_pipe(false)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local result = {}

    local startln = vim.fn.searchpos('^```R', 'bnW')[1]
    local endln = vim.fn.searchpos('^```$', 'nW')[1]

    if startln == 0 or endln == 0 then
        return -1
    end

    local onread = vim.schedule_wrap(function(err, data)
        if err then
            print('ERROR: ', err)
            -- TODO handle err
        end
        if data then
            local lines = vim.split(string.gsub(data, '\n$', ''), '\n')
            for n,l in ipairs(lines) do
                lines[n] = '# ' .. l
            end
            vim.list_extend(result, lines)
        end
    end)

    local r_handle
    r_handle = vim.loop.spawn('R', {
            args = {'--slave', '--no-readline'},
            stdio = {stdin, stdout, stderr},
        },
        vim.schedule_wrap(function(code, signal)
            stdin:close()
            stdout:close()
            stderr:close()
            r_handle:close()
            print('exit with', code, signal)
            vim.fn.append(vim.fn.searchpos('^```$', 'nW')[1]-1, result)
        end)
    )

    -- add header
    if vim.g.hexowiki_r_result_header then
        vim.list_extend(result, vim.g.hexowiki_r_result_header)
    end

    -- get input and run
    local lines = vim.api.nvim_buf_get_lines(0, startln, endln-1, true)
    vim.loop.write(stdin, vim.fn.join(lines, '\n'))
    stdin:shutdown()

    vim.loop.read_start(stdout, onread)
    vim.loop.read_start(stderr, onread)
end

return M
