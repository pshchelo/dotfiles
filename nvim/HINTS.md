# Hints, tricks and workarounds for NeoVim

## Treesitter
### find where treesitter parsers are installed
to know what to wipe if need to re-install from scratch
```
:echo nvim_get_runtime_file('parser/*.so', v:true)
```

### `client.is_stopped is deprecated` warning on start

Some plugin uses old syntax, replace `.is_stopped` with `:is_stopped`.
In my particular case, definitely `copilit-cmp` is to blame,
see [this pull request](https://github.com/zbirenbaum/copilot-cmp/pull/128).

Potentially also in `nvim-lspconfig/plugin/lspconfig.lua` too, but that would
be triggered only on specific command, not automatically.

