{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jjorgens";
  home.homeDirectory = "/home/jjorgens";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # nixpkgs.config = {
  #   allowUnfree = true;
  #   rocmSupport = true;
  # };
  
  home.packages = with pkgs; [
    # One imagines that one would need to install an emacs variant
    # before installing packages, but that appears to not be the case.
    # emacs-git
    aider-chat
    amdgpu_top
    awscli2
    bottom
    btop
    dos2unix
    firefox
    font-awesome
    fzf
    gawk
    git
    git-lfs
    grimblast
    htop
    jq
    keepassxc
    mako
    nextcloud-client
    nmap
    pavucontrol
    pwgen
    ripgrep
    slack
    steam
    thunderbird
    tree
    waybar
    wget
    
    ((emacsPackagesFor emacs-unstable).emacsWithPackages (epkgs: [
      epkgs.auto-complete
      epkgs.company
      epkgs.company-irony
      epkgs.company-quickhelp
      epkgs.counsel
      epkgs.csv-mode
      epkgs.direnv
      epkgs.exec-path-from-shell
      epkgs.flycheck
      epkgs.flycheck-irony
      epkgs.gptel
      epkgs.irony
      epkgs.irony-eldoc
      epkgs.js2-mode
      epkgs.llama
      epkgs.magit
      epkgs.markdown-mode
      epkgs.multi-vterm
      epkgs.nix-mode
      epkgs.org-tree-slide
      epkgs.platformio-mode
      epkgs.popup
      epkgs.pos-tip
      epkgs.projectile
      epkgs.rust-mode
      epkgs.swiper
      epkgs.toml-mode
      epkgs.vterm
      epkgs.web-mode
      epkgs.with-editor
      epkgs.yaml-mode
      epkgs.yasnippet
      epkgs.yasnippet-snippets
    ]))
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # home-manager to control fonts
  fonts.fontconfig.enable = true;
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jjorgens/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "emacs";
    WLR_NO_HARDWARE_CURSORS = 1;
  };

  # temporary extra path
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      ls = "ls --color";
      ll = "ls -AlF --color";
      la = "ls -A --color";
      l = "ls -CF --color";
    };
    sessionVariables = {
      GIT_PS1_SHOWDIRTYSTATE = 1;
    };
    bashrcExtra = ''
# reclaim ctl-s and ctl-q from tty
stty -ixon -ixoff

# readline settings
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'
bind 'TAB: menu-complete'
bind '"\e[Z": menu-complete-backward'

# aws completion
complete -C '$HOME/.nix-profile/bin/aws_completer' aws

# git completion
source $HOME/.nix-profile/share/git/contrib/completion/git-completion.bash

# There are many like it, but this one is mine.
# I can't seem to get this to work in the sessionVariables section
source $HOME/.nix-profile/share/git/contrib/completion/git-prompt.sh
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$(__git_ps1 "(%s)")\$\[\e[m\] \[\e[1;37m\]'
'';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=11";
        dpi-aware = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.waybar = import ./waybar.nix;
  
  programs.wofi = import ./wofi.nix;

  
  # ssh-agent
  services.ssh-agent.enable = true;

  # set popular env (XDG_DATA_HOME, etc.)
  targets.genericLinux.enable = true;

  # used with hyprland
  programs.kitty.enable = true;
  
  wayland.windowManager = {
    # sway
    # sway = {
    #   enable = true;
    #   wrapperFeatures.gtk = true;
    #   config = rec {
    #     modifier = "Mod4";
    #     menu = "wofi --show";
    #     bars = [{
    #       command = "waybar";
    #     }];
    #     input = {
    #       "*" = { xkb_options = "ctrl:nocaps,ctrl:swapcaps"; };
    #     };
    #   };
    # };
    # hyprland
    hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$menu" = "wofi --show";
        bind =
          [
            "$mod, D, exec, $menu"
            "$mod, Return, exec, kitty"
            "$mod SHIFT, E, exit"
            "$mod, V, toggleFloating"
            "$mod, P, pseudo"
            "$mod, J, togglesplit"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            "$mod SHIFT, left, movewindow, l"
            "$mod SHIFT, right, movewindow, r"
            "$mod SHIFT, up, movewindow, u"
            "$mod SHIFT, down, movewindow, d"
            "$mod, Q, killactive,"
            # audio
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            # screenies
            #  Active window
            ", print, exec, grimblast save active"
            #  Save area
            "$mod, print, exec, grimblast save area"
            #  Save whole screen
            "$mod CTRL, print, exec, grimblast save screen"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
              9)
          );
        bindm =
          [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
        decoration = {
          rounding = "10";
        };
        exec-once = "waybar";
        general = {
          gaps_out = "10";
        };
        input = {
          kb_options = "ctrl:nocaps,ctrl:swapcaps";
        };
        misc = {
          disable_hyprland_logo = "true";
          force_default_wallpaper = "0";
        };
        monitor = ", preferred, auto, 1";
      };
    };
  };
}
