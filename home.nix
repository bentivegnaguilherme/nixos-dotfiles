  { config, pkgs, noctalia, unstable, username, ... }:
 
  {
     imports = [ noctalia.homeModules.default ];

     home = {
       username = username;
       homeDirectory = "/home/${username}";
       stateVersion = "26.05";
packages = with pkgs; [
          kitty
          fish
          firefox
          tree
          neovim
          git
          unstable.opencode # from the unstable channel; lags less than stable pin (see flake.nix)
          pulseaudio
          starship
          wl-clipboard # nvim system clipboard (wl-copy/wl-paste)
          lazygit # <leader>gg in LazyVim
          ripgrep # telescope live-grep
          fd # telescope file finding
          gcc # tree-sitter parser + avante build
          gnumake # avante build step
          bibata-cursors # Bibata-Modern-Classic (black) cursor theme
          # Static Papirus-Dark with black folders; recolored at build time.
          # Derivation name must NOT contain "-black": papirus-folders strips
          # the first "-<color>" occurrence in the path when relinking icons.
          (runCommand "papirus-icon-theme-blk"
            { nativeBuildInputs = [ papirus-folders ]; }
            ''
              mkdir -p $out/share/icons
              cp -r ${papirus-icon-theme}/share/icons/Papirus \
                    ${papirus-icon-theme}/share/icons/Papirus-Dark \
                    ${papirus-icon-theme}/share/icons/hicolor \
                    $out/share/icons/
              chmod -R u+w $out/share/icons
              export HOME=$TMPDIR
              XDG_DATA_DIRS="$out/share" papirus-folders -o -t Papirus-Dark -C black
            '')
          nautilus # file manager
          gvfs # trash, network, device mounting for nautilus
          obsidian # notes; vault at ~/notes, auto-synced to a private GitHub repo
          lazygit # git TUI; <leader>gg inside Neovim opens it floating
          unzip # mason package installs
          gh # github cli
        ];

        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "24";
        };

        file.".config/niri/config.kdl".source = ./niri-config.kdl;
        # Tridactyl auto-sources this at startup once the native messenger
        # is installed (:installnative in any tab).
        file.".config/tridactyl/tridactylrc".source = ./assets/tridactylrc;
        file.".config/noctalia/config.toml".source = ./noctalia-config.toml;
        file.".config/fish/config.fish".source = ./fish-config.fish;
        file.".config/kitty/kitty.conf".source = ./kitty.conf;
        file.".config/nvim".source = ./nvim;
      };

      # Per-project dev environments: "use flake" in a project's .envrc
      # loads its tools on cd, unloads on leave. nix-direnv caches so
      # re-entry is instant.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # GTK apps (nautilus, firefox) pick the cursor from gsettings, not env vars.
      dconf.settings."org/gnome/desktop/interface" = {
        cursor-theme = "Bibata-Modern-Classic";
        cursor-size = 24;
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
        icon-theme = "Papirus-Dark";
        font-name = "DejaVu Sans 11";
      };

      # System-wide font defaults: standard sans for app UIs; kitty keeps
      # its monospace look via fontconfig's monospace default.
      fonts.fontconfig.defaultFonts.sansSerif = [ "DejaVu Sans" ];
      fonts.fontconfig.defaultFonts.monospace = [ "DejaVu Sans Mono" ];

      # Noctalia themes GTK apps via CSS only; it never writes settings.ini.
      # Firefox's System Theme reads the GTK theme name / dark flag instead,
      # so declare them here or it renders light.
      xdg.configFile."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=Adwaita-dark
        gtk-application-prefer-dark-theme=true
      '';
      xdg.configFile."gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=Adwaita-dark
        gtk-application-prefer-dark-theme=true
      '';

      # Firefox has no Noctalia template; sync its UI colors by converting
      # Noctalia's generated GTK palette into userChrome.css for every profile.
      # Same script emits an opencode TUI theme from the same palette.
      xdg.configFile."noctalia/theme-sync.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          # Regenerate app themes from Noctalia's generated GTK palette.
          set -eu
          CSS="$HOME/.config/gtk-4.0/noctalia.css"
          [ -f "$CSS" ] || exit 0
          get() { sed -n "s/^@define-color[[:space:]]*$1[[:space:]]*\(#[0-9a-fA-F]*\).*/\1/p" "$CSS" | head -1; }
          BG=$(get window_bg_color)
          FG=$(get window_fg_color)
          ACC=$(get accent_color)
          CARD=$(get card_bg_color)
          POP=$(get popover_bg_color)
          SIDEBAR=$(get sidebar_bg_color)
          MUT=$(get theme_unfocused_fg_color)
          BORD=$(get sidebar_border_color)
          RED=$(get destructive_bg_color)
          SEL=$(get theme_selected_bg_color)
          : "''${BG:=#1b1b1f}" "''${FG:=#e3e3e8}" "''${ACC:=#8ab4ff}"
          : "''${CARD:=#24242c}" "''${POP:=#2a2a33}" "''${SIDEBAR:=#202028}"
          : "''${MUT:=#8b8d98}" "''${BORD:=#2e3037}" "''${RED:=#ffb4ab}" "''${SEL:=$ACC}"

          # --- Firefox userChrome.css ---
          CHROME="/* Generated by noctalia-theme-sync.sh - do not edit */
          :root {
            --lwt-text-color: $FG !important;
            --toolbar-color: $FG !important;
            --tab-selected-textcolor: $FG !important;
            --arrowpanel-background: $POP !important;
            --arrowpanel-color: $FG !important;
            --panel-color: $FG !important;
            --autocomplete-popup-color: $FG !important;
            --sidebar-text-color: $FG !important;
          }
          /* Paint chrome elements directly: --lwt-* background vars are
             ignored unless a lightweight theme is active. */
          #navigator-toolbox, #TabsToolbar, #nav-bar { background-color: $BG !important; }
          #PersonalToolbar { background-color: $CARD !important; }
          .tab-background[selected]:not([multiselected]) {
            background-color: $POP !important;
          }
          .tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected]) {
            background-color: color-mix(in srgb, $ACC 14%, transparent) !important;
          }
          #sidebar-box, .browser-sidebar2 { background-color: $SIDEBAR !important; }
          findbar { background-color: $CARD !important; }
          menupopup { background-color: $POP !important; }
          menupopup > menu:hover,
          menupopup > menuitem:hover {
            background: color-mix(in srgb, $ACC 22%, transparent) !important;
          }"
          # Find every registered profile via profiles.ini (Firefox may live
          # under ~/.config/mozilla or the legacy ~/.mozilla).
          for ini in "$HOME/.config/mozilla/firefox/profiles.ini" "$HOME/.mozilla/firefox/profiles.ini"; do
            [ -f "$ini" ] || continue
            root=$(dirname "$ini")
            while IFS= read -r p; do
              [ -n "$p" ] || continue
              case "$p" in
                /*) prof="$p" ;;
                *) prof="$root/$p" ;;
              esac
              [ -d "$prof" ] || continue
              mkdir -p "$prof/chrome"
              printf '%s\n' "$CHROME" > "$prof/chrome/userChrome.css"
            done < <(grep '^Path=' "$ini" | cut -d= -f2-)
          done

          # --- opencode TUI theme ---
          mkdir -p "$HOME/.config/opencode/themes"
          cat > "$HOME/.config/opencode/themes/noctalia.json" <<EOF
          {
            "\$schema": "https://opencode.ai/theme.json",
            "defs": {
              "bg": "$BG", "panel": "$CARD", "elem": "$POP", "fg": "$FG",
              "muted": "$MUT", "accent": "$ACC", "border": "$BORD",
              "sel": "$SEL", "red": "$RED", "green": "#9ece8f"
            },
            "theme": {
              "primary": { "dark": "accent", "light": "accent" },
              "secondary": { "dark": "sel", "light": "sel" },
              "accent": { "dark": "accent", "light": "accent" },
              "error": { "dark": "red", "light": "red" },
              "warning": { "dark": "red", "light": "red" },
              "info": { "dark": "accent", "light": "accent" },
              "success": { "dark": "green", "light": "green" },
              "text": { "dark": "fg", "light": "fg" },
              "textMuted": { "dark": "muted", "light": "muted" },
              "background": { "dark": "bg", "light": "bg" },
              "backgroundPanel": { "dark": "panel", "light": "panel" },
              "backgroundElement": { "dark": "elem", "light": "elem" },
              "border": { "dark": "border", "light": "border" },
              "borderActive": { "dark": "accent", "light": "accent" },
              "borderSubtle": { "dark": "border", "light": "border" },
              "diffAdded": { "dark": "green", "light": "green" },
              "diffRemoved": { "dark": "red", "light": "red" },
              "diffContext": { "dark": "muted", "light": "muted" },
              "diffHunkHeader": { "dark": "muted", "light": "muted" },
              "diffHighlightAdded": { "dark": "green", "light": "green" },
              "diffHighlightRemoved": { "dark": "red", "light": "red" },
              "diffAddedBg": { "dark": "panel", "light": "panel" },
              "diffRemovedBg": { "dark": "panel", "light": "panel" },
              "diffContextBg": { "dark": "bg", "light": "bg" },
              "diffLineNumber": { "dark": "border", "light": "border" },
              "markdownText": { "dark": "fg", "light": "fg" },
              "markdownHeading": { "dark": "accent", "light": "accent" },
              "markdownLink": { "dark": "sel", "light": "sel" },
              "markdownLinkText": { "dark": "accent", "light": "accent" },
              "markdownCode": { "dark": "green", "light": "green" },
              "markdownBlockQuote": { "dark": "muted", "light": "muted" },
              "markdownEmph": { "dark": "red", "light": "red" },
              "markdownStrong": { "dark": "fg", "light": "fg" },
              "syntaxComment": { "dark": "muted", "light": "muted" },
              "syntaxKeyword": { "dark": "sel", "light": "sel" },
              "syntaxFunction": { "dark": "accent", "light": "accent" },
              "syntaxVariable": { "dark": "fg", "light": "fg" },
              "syntaxString": { "dark": "green", "light": "green" },
              "syntaxNumber": { "dark": "red", "light": "red" },
              "syntaxType": { "dark": "sel", "light": "sel" },
              "syntaxOperator": { "dark": "sel", "light": "sel" },
              "syntaxPunctuation": { "dark": "muted", "light": "muted" }
            }
          }
          EOF
          # --- Obsidian vault snippet ---
          # Obsidian watches its snippets dir, so wallpaper changes apply live.
          if [ -d "$HOME/notes/.obsidian" ]; then
            mkdir -p "$HOME/notes/.obsidian/snippets"
            hex2hsl() {
              local h="''${1#\#}"
              awk -v r=$((16#''${h:0:2})) -v g=$((16#''${h:2:2})) -v b=$((16#''${h:4:2})) 'BEGIN{
                r/=255;g/=255;b/=255;
                mx=r;if(g>mx)mx=g;if(b>mx)mx=b;
                mn=r;if(g<mn)mn=g;if(b<mn)mn=b;
                d=mx-mn;l=(mx+mn)/2;
                if(d==0){h=0;s=0}
                else{
                  den=1-((2*l-1)<0?-(2*l-1):(2*l-1));
                  s=d/den;
                  if(mx==r)h=60*(((g-b)/d)+6)%6;
                  else if(mx==g)h=60*((b-r)/d+2);
                  else h=60*((r-g)/d+4);
                }
                printf "%d %d %d", h, s*100+0.5, l*100+0.5
              }'
            }
            read -r AH AS AL <<< "$(hex2hsl "$ACC")"
            ACC_FG=$(get accent_fg_color)
            : "''${ACC_FG:=#000000}"
            {
              echo "/* Generated by noctalia-theme-sync.sh - follows the wallpaper */"
              echo "body {"
              echo "  --accent-h: $AH;"
              echo "  --accent-s: $AS%;"
              echo "  --accent-l: $AL%;"
              echo "  --interactive-accent: $ACC;"
              echo "  --interactive-accent-hover: $ACC;"
              echo "  --text-on-accent: $ACC_FG;"
              echo "  --background-primary: $BG;"
              echo "  --background-primary-alt: $CARD;"
              echo "  --background-secondary: $CARD;"
              echo "  --background-secondary-alt: $POP;"
              echo "  --background-modifier-border: $BORD;"
              echo "  --text-normal: $FG;"
              echo "  --text-muted: $MUT;"
              echo "  --text-faint: $MUT;"
              echo "}"
            } > "$HOME/notes/.obsidian/snippets/noctalia.css"
          fi
        '';
      };
      systemd.user.services.noctalia-theme-sync = {
        Unit.Description = "Sync app themes (Firefox, opencode, Obsidian) with Noctalia";
        Service = {
          Type = "oneshot";
          ExecStart = "%h/.config/noctalia/theme-sync.sh";
        };
      };
      systemd.user.paths.noctalia-theme-sync = {
        Unit.Description = "Watch Noctalia GTK palette for changes";
        Path.PathChanged = [ "%h/.config/gtk-4.0/noctalia.css" ];
        Install.WantedBy = [ "default.target" ];
      };

      # Obsidian vault backup: commit + push ~/notes to the private
      # `notes` GitHub repo every 15 minutes. Pulls first so edits made
      # on machine #2 come down automatically.
      xdg.configFile."notes/sync.sh".text = ''
        #!/usr/bin/env bash
        set -euo pipefail
        cd "$HOME/notes" || exit 0
        [ -d .git ] || exit 0
        git add -A
        git diff --cached --quiet || git commit -q -m "vault sync $(date '+%Y-%m-%d %H:%M')"
        git pull --rebase -q origin main || true
        git push -q origin main 2>/dev/null || true
      '';
      systemd.user.services.notes-sync = {
        Unit.Description = "Commit and push Obsidian vault to GitHub";
        Service = {
          Type = "oneshot";
          ExecStart = "%h/.config/notes/sync.sh";
        };
      };
      systemd.user.timers.notes-sync = {
        Unit.Description = "Periodic Obsidian vault sync";
        Timer = {
          OnBootSec = "5min";
          OnUnitActiveSec = "15min";
        };
        Install.WantedBy = [ "timers.target" ];
      };

      # Use the generated Noctalia theme in opencode's TUI.
      xdg.configFile."opencode/tui.json".text = ''
        {
          "$schema": "https://opencode.ai/tui.json",
          "theme": "noctalia"
        }
      '';

      # Arch logo for the Noctalia bar launcher button.
      xdg.configFile."noctalia/arch-logo.svg".source = ./assets/arch-logo.svg;

    xdg.configFile."wireplumber/wireplumber.conf.d/50-bluez-a2dp.conf".text = ''
      monitor.bluez.rules = [
        {
          matches = [
            {
              device.name = "~bluez_card.F4_4E_FC_EB_62_87$"
            }
          ]
          actions = {
            update-props = {
              bluez5.profiles = [ a2dp_sink ]
            }
          }
        }
      ]
    '';

    programs = {
      bash = {
        enable = true;
        shellAliases = {
          btw = "echo i use arch btw";
        };
      };
      noctalia = {
        enable = true;
      };
      # Terminal multiplexer running the famous gpakosz/.tmux (Oh My Tmux)
      # config, vendored + pinned in assets/tmux/ and customized there
      # (C-a prefix, mouse, Alt+hjkl pane nav that hands off to Neovim).
      tmux.enable = true;
    };

    # Oh My Tmux lives in ~/.tmux.conf (tmux prefers it over XDG paths)
    home.file = {
      ".tmux.conf".source = ./assets/tmux/tmux.conf;
      ".tmux.conf.local".source = ./assets/tmux/tmux.conf.local;
    };
  }  
