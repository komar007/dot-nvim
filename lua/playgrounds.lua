local pg = require('playground')
local utils = require('utils')

pg.make_playground('rust', function()
  vim.fn.system({ 'cargo', 'init', '.' })
  return 'src/main.rs'
end)

local maingo = [[
package main


import "fmt"

func main() {
    fmt.Println("hello world")
}
]]
pg.make_playground('go', function()
  utils.initialize_file('main.go', maingo)
  return 'main.go'
end)
