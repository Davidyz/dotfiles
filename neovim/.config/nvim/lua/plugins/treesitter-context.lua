require('treesitter-context').setup{
    enable = true,
    throttle = true,
    max_lines = 0,
    patterns = {
        default = {
            'class',
            'function',
            'method',
            'for', -- These won't appear in the context
            'while',
            'if',
            'switch',
            'case',
        },
    }
}
