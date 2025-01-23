{ pkgs
, ...
}: {
  vim = {
    keymaps = [
      {
        key = "<leader>lF";
        mode = [ "n" ];
        action = ":!nix fmt\n";
        desc = "Format all project";
      }

      {
        key = "<leader>G";
        mode = [ "n" ];
        action = ":Neogit\n";
        desc = "Open neogit";
      }

      {
        key = "<leader><leader>h";
        mode = [ "n" ];
        action = ":SmartCursorMoveLeft\n";
      }

      {
        key = "<leader><leader>l";
        mode = [ "n" ];
        action = ":SmartCursorMoveRight\n";
      }

      {
        key = "<leader><leader>j";
        mode = [ "n" ];
        action = ":SmartCursorMoveDown\n";
      }

      {
        key = "<leader><leader>k";
        mode = [ "n" ];
        action = ":SmartCursorMoveUp\n";
      }

      {
        key = "<leader><leader>H";
        mode = [ "n" ];
        action = ":SmartResizeLeft ";
      }

      {
        key = "<leader><leader>L";
        mode = [ "n" ];
        action = ":SmartResizeRight ";
      }

      {
        key = "<leader><leader>J";
        mode = [ "n" ];
        action = ":SmartResizeDown ";
      }

      {
        key = "<leader><leader>K";
        mode = [ "n" ];
        action = ":SmartResizeUp ";
      }

      {
        key = "<leader><leader><C-h>";
        mode = [ "n" ];
        action = ":SmartSwapLeft\n";
      }

      {
        key = "<leader><leader><C-l>";
        mode = [ "n" ];
        action = ":SmartSwapRight\n";
      }

      {
        key = "<leader><leader><C-k>";
        mode = [ "n" ];
        action = ":SmartSwapUp\n";
      }

      {
        key = "<leader><leader><C-j>";
        mode = [ "n" ];
        action = ":SmartSwapDown\n";
      }

      {
        key = "<leader><leader>n";
        mode = [ "n" ];
        action = ":vsplit\n";
        desc = "Ouvrir un split horizontal";
      }

      {
        key = "<leader><leader>v";
        mode = [ "n" ];
        action = ":split\n";
        desc = "Ouvrir un split vertical";
      }

    ];

    startPlugins = [
      pkgs.vimPlugins.neogit
      pkgs.vimPlugins.smart-splits-nvim
    ];

    viAlias = true;
    vimAlias = true;
    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    spellcheck = {
      enable = false;
    };

    lsp = {
      enable = true;
      formatOnSave = false;
      lspkind.enable = false;
      lightbulb.enable = true;
      trouble.enable = true;
      lspSignature.enable = true;
      otter-nvim.enable = true;
      lsplines.enable = true;
      nvim-docs-view.enable = true;
      lspconfig.enable = true;
      null-ls.enable = true;
      lspsaga.enable = true;
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    options = {
      tabstop = 4;
    };

    # This section does not include a comprehensive list of available language modules.
    # To list all available language module options, please visit the nvf manual.;
    languages = {
      enableLSP = true;
      enableFormat = false;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # Languages that will be supported in default and maximal configurations.
      nix.enable = true;
      markdown.enable = true;

      # Languages that are enabled in the maximal configuration.
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      html.enable = true;
      sql.enable = true;
      java.enable = true;
      ts = {
        enable = true;
        extraDiagnostics.enable = false;
        format.enable = true;
      };
      go.enable = true;
      lua.enable = true;
      zig.enable = true;
      python.enable = true;
      typst.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
      };

      # Language modules that are not as common.
      assembly.enable = false;
      astro.enable = false;
      nu.enable = false;
      csharp.enable = false;
      julia.enable = false;
      vala.enable = false;
      scala.enable = false;
      r.enable = false;
      gleam.enable = false;
      dart = {
        enable = true;
        flutter-tools.enable = true;
      };
      ocaml.enable = false;
      elixir.enable = false;
      haskell.enable = false;

      tailwind.enable = false;
      svelte.enable = false;

      # Nim LSP is broken on Darwin and therefore
      # should be disabled by default. Users may still enable
      # `vim.languages.vim` to enable it, this does not restrict
      # that.
      # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
      nim.enable = false;
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;

      # Fun
      cellular-automaton.enable = true;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete.nvim-cmp.enable = true;
    runner.run-nvim.enable = true;

    filetree = {
      neo-tree = {
        enable = true;
      };
    };

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns.enable = false;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
    };

    minimap = {
      codewindow.enable = true;
    };

    dashboard = {
      dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      # icon-picker.enable = true;
      surround.enable = true;
      diffview-nvim.enable = true;
      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = false;
      };
    };

    notes = {
      orgmode.enable = true;
      mind-nvim.enable = true;
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = [ "90" "130" ];
        };
      };
      fastaction.enable = true;
    };

    session = {
      nvim-session-manager.enable = false;
    };

    comments = {
      comment-nvim.enable = true;
    };

    mini = {
      sessions.enable = true;
      animate.enable = true;
      indentscope.enable = true;
    };
  };
}
