local LAZY_GITHUB = "https://github.com/folke/lazy.nvim.git"
local LOCKFILE = vim.fn.stdpath("config") .. "/lazy-lock.json"
local LAZYPATH = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@generic T
---@param die_msg string
---@param val T?
---@return T
local function or_die_with(die_msg, val)
  if val ~= nil then
    return val
  else
    vim.api.nvim_echo({
      { "ERROR: " .. die_msg .. "\n", "ErrorMsg" },
    }, true, {})
    os.exit(1)
  end
end

---@param die_msg string
---@param cmd string[]
local function shell_or_die_with(die_msg, cmd)
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    or_die_with(die_msg .. ": " .. out, nil)
  end
end

local lockfile_json = or_die_with("could not open lazy-lock.json", io.open(LOCKFILE))
local lockfile = or_die_with("could not read lazy-lock.json", lockfile_json:read("*a"))
local ok, json = pcall(vim.json.decode, lockfile)
if not ok then
  or_die_with("could no decode lazy-lock.json as JSON: " .. json, nil)
end
local lazy_entry = or_die_with("lazy.nvim entry missing from lazy-lock.json", (json or {})["lazy.nvim"])
local branch = lazy_entry.branch
local commit = lazy_entry.commit

if not vim.uv.fs_stat(LAZYPATH) then
  shell_or_die_with("Failed to clone lazy.nvim",
    { "git", "clone", "--filter=blob:none", "--branch=" .. branch, LAZY_GITHUB, LAZYPATH })
  shell_or_die_with("Failed to check out locked lazy.nvim " .. commit,
    { "git", "-C", LAZYPATH, "checkout", commit })
end

vim.opt.rtp:prepend(LAZYPATH)
