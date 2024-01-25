return {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "stylua",
            "shellcheck",
            "shfmt",
            "flake8",
            "clangd",
            "clang-format",
            "typescript-language-server",
            "pyright",
            "codelldb"
        },
    },
}
