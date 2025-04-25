return {
    root_dir = function(fname)
        local install_path = "node_modules/tailwindcss"
        return vim.fs.find(install_path, { upward = true, path = fname, type = "directory" })[1]
    end,
}
