return {
    "lg-epitech/epi_headers",
    config = function()
        vim.cmd("nnoremap tek <cmd>lua require('headers').insert_header()<CR>")
    end,
}
