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
  home.packages = with pkgs; [
    # One imagines that one would need to install an emacs variant
    # before installing packages, but that appears to not be the case.
    # emacs-git
    awscli2
    bottom
    dos2unix
    firefox
    fzf
    gawk
    git
    git-lfs
    htop
    jq
    keepassxc
    mako
    nerdfonts
    nextcloud-client
    nmap
    pavucontrol
    pwgen
    ripgrep
    slack
    steam
    swaylock
    swayidle
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
      epkgs.magit
      epkgs.markdown-mode
      epkgs.multi-vterm
      epkgs.nix-mode
      epkgs.org-tree-slide
      epkgs.platformio-mode
      epkgs.popup
      epkgs.projectile
      epkgs.rust-mode
      epkgs.toml-mode
      epkgs.vterm
      epkgs.web-mode
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

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "clock" ];
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        "pulseaudio" = {
          "on-click" = "pavucontrol";
        };
      };
    };
    style = ''
* {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: Roboto, Helvetica, Arial, sans-serif;
    font-size: 18px;
}

window#waybar {
    background-color: rgba(43, 48, 59, 0.5);
    border-bottom: 3px solid rgba(100, 114, 125, 0.5);
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}

/*
window#waybar.empty {
    background-color: transparent;
}
window#waybar.solo {
    background-color: #FFFFFF;
}
*/

window#waybar.termite {
    background-color: #3F3F3F;
}

window#waybar.chromium {
    background-color: #000000;
    border: none;
}

#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: #ffffff;
    /* Use box-shadow instead of border so the text isn't offset */
    box-shadow: inset 0 -3px transparent;
    /* Avoid rounded borders under each workspace name */
    border: none;
    border-radius: 0;
}

/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button.focused {
    background-color: #64727D;
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button.urgent {
    background-color: #eb4d4b;
}

#mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#custom-media,
#tray,
#mode,
#idle_inhibitor {
    padding: 0 10px;
    color: #ffffff;
}

#window,
#workspaces {
    margin: 0 4px;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
    margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
    margin-right: 0;
}

#clock {
    background-color: #64727D;
}

#battery {
    background-color: #ffffff;
    color: #000000;
}

#battery.charging, #battery.plugged {
    color: #ffffff;
    background-color: #26A65B;
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}

#battery.critical:not(.charging) {
    background-color: #f53c3c;
    color: #ffffff;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

label:focus {
    background-color: #000000;
}

#cpu {
    background-color: #2ecc71;
    color: #000000;
}

#memory {
    background-color: #9b59b6;
}

#disk {
    background-color: #964B00;
}

#backlight {
    background-color: #90b1b1;
}

#network {
    background-color: #2980b9;
}

#network.disconnected {
    background-color: #f53c3c;
}

#pulseaudio {
    background-color: #f1c40f;
    color: #000000;
}

#pulseaudio.muted {
    background-color: #90b1b1;
    color: #2a5c45;
}

#custom-media {
    background-color: #66cc99;
    color: #2a5c45;
    min-width: 100px;
}

#custom-media.custom-spotify {
    background-color: #66cc99;
}

#custom-media.custom-vlc {
    background-color: #ffa000;
}

#temperature {
    background-color: #f0932b;
}

#temperature.critical {
    background-color: #eb4d4b;
}

#tray {
    background-color: #2980b9;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}

#idle_inhibitor {
    background-color: #2d3436;
}

#idle_inhibitor.activated {
    background-color: #ecf0f1;
    color: #2d3436;
}

#language {
    background: #00b093;
    color: #740864;
    padding: 0 5px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state {
    background: #97e1ad;
    color: #000000;
    padding: 0 0px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state > label {
    padding: 0 5px;
}

#keyboard-state > label.locked {
    background: rgba(0, 0, 0, 0.2);
}
'';
  };
  
  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun";
      allow_images = "true";
      width = "20%";
    };
    style = ''
window {
    font-size: x-large;
    background-color: rgba(50, 50, 50, 0.9);
    color: white;
}

#input {
    background-color: rgba(50, 50, 50, 0.9);
    color: white;
}
'';
  };
  
  # ssh-agent
  services.ssh-agent.enable = true;

  # set popular env (XDG_DATA_HOME, etc.)
  targets.genericLinux.enable = true;

  # sway
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      menu = "wofi --show";
      bars = [{
        command = "waybar";
      }];
      input = {
        "*" = { xkb_options = "ctrl:nocaps,ctrl:swapcaps"; };
      };
    };
  };
}
