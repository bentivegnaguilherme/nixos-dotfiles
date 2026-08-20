set -g fish_greeting # disable the welcome message

if status is-interactive
    starship init fish | source
end
