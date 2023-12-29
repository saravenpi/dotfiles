set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux CODE $HOME/code
set -Ux SCHOOL $HOME/school/
set currentdate = (date)
set -U fish_user_paths $HOME/go/bin/ $fish_user_paths
set -U fish_user_paths $HOME/.bun/bin/ $fish_user_paths
set -Ux OPENAI_API_KEY (cat $HOME/.openai)
