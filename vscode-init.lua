-- ~/.config/nvim/vscode-init.lua

-- 默认使用系统剪贴板（y/p 都走系统 clipboard）
-- vim.o.clipboard = 'unnamedplus'

-- yank 高亮
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('vscode-yank-highlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank-to-clipboard-only', { clear = true }),
  callback = function()
    if vim.v.event.operator == 'y' then
      local text = vim.fn.getreg '"'
      local regtype = vim.fn.getregtype '"'
      vim.fn.setreg('+', text, regtype)
    end
  end,
})


-- 确保这仅在 VS Code 环境中运行
if vim.g.vscode then
  -- 定义一个智能的 gj/gk 映射，明确遵守数字修饰符(Count)

  -- 向下导航逻辑 (拦截 j)
  vim.keymap.set({ 'n', 'x' }, 'j', function()
    -- 检查 j 之前是否输入了数字
    if vim.v.count == 0 then
      -- 如果计数为 0，用户只是按下了 'j'。
      -- 返回 "gj" 按显示行移动，完美跳过折叠代码块。
      return 'gj'
    else
      -- 如果计数 > 0（例如，用户输入了 '10j'），他们需要绝对逻辑跳转。
      -- 返回标准的 "j" 按逻辑行移动，保持行数准确性。
      return 'j'
    end
  end, { expr = true, remap = true, silent = true })

  -- 向上导航逻辑 (拦截 k)
  vim.keymap.set({ 'n', 'x' }, 'k', function()
    -- 对向上移动采用相同的逻辑
    if vim.v.count == 0 then
      return 'gk'
    else
      return 'k'
    end
  end, { expr = true, remap = true, silent = true })
end
