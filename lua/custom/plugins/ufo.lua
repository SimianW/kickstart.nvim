-- nvim-ufo: better fold support with treesitter
local gh = function(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'kevinhwang91/promise-async' }
vim.pack.add { gh 'kevinhwang91/nvim-ufo' }

-- UFO 要求这几个全局选项
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99      -- 打开文件时默认全部展开
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup {
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
  -- 折叠行末尾显示折叠内容预览
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' ⏷ %d lines'):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        table.insert(newVirtText, { chunkText, chunk[2] })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
  end,
}

-- 快捷键
vim.keymap.set('n', 'zR', require('ufo').openAllFolds,  { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
