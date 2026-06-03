return {
  "folke/snacks.nvim",

  opts = {
    picker = {
      -- Forces Neovim out of insert mode the moment ANY picker opens
      -- The idea here is that all "pop-up" behave the same: Explorer, File navigator, string
      -- search,... all open in normal mode and let you navigate to the (potential) non-filtered list
      -- and requires you to explicitely type i to enter insert mode
      on_show = function()
        vim.cmd.stopinsert()
      end,
      hidden = true,
      ignored = true,
      -- Configure the custom keymap for the explorer source
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                -- Safe: Capital 'D' avoids overwriting the default 'd' deletion key
                ["D"] = "diff_files",
              },
              -- show number in explorer to navigate more easily with vim motions like 25j
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
        },
      },

      -- Define the custom visual diff action logic
      actions = {
        diff_files = function(picker)
          local selected = picker:selected({ split = true })

          -- Fallback: Use the item under the cursor if nothing is tab-selected
          if #selected == 0 then
            local item = picker:current()
            if item and item.file then
              table.insert(selected, item)
            end
          end

          -- Validation: Guard against 3 or more selections
          if #selected > 2 then
            vim.notify(
              string.format("Cannot diff %d files. Please select exactly 1 or 2 files.", #selected),
              vim.log.levels.WARN,
              { title = "Snacks Explorer Diff" }
            )
            return -- Halts execution and keeps explorer open to fix selections
          end

          -- Close the explorer only after validation passes
          picker:close()

          if #selected == 1 then
            -- Diff the 1 chosen file against your active buffer
            vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(selected[1].file))
          elseif #selected == 2 then
            -- Compare the 2 tab-selected items side-by-side
            vim.cmd("edit " .. vim.fn.fnameescape(selected[1].file))
            vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(selected[2].file))
          else
            vim.notify("No valid files found to diff", vim.log.levels.ERROR)
          end
        end,
      },
    },
  },
}
