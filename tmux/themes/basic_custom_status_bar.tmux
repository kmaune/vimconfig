# Custom tmux theme
# This file contains tmux configuration directives for custom styling

# Status bar customization
set -g status-bg colour234
set -g status-fg colour137
set -g status-left-length 20
set -g status-right-length 50
set -g status-left '#[fg=colour233,bg=colour241,bold] #S #[fg=colour241,bg=colour235,nobold]'
set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '

# Window status formatting
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

# Pane border colors
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour51
