# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'
set __fish_git_prompt_char_upstream_equal ''

function fish_prompt
  set -l last_status $status
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
  end
  if not set -q __fish_prompt_user
    set -g __fish_prompt_user (set_color $fish_color_user)
  end
  if not set -q __fish_prompt_host
    set -g __fish_prompt_host (set_color $fish_color_host)
  end
  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end
  if not set -q __fish_prompt_cwd
    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
  end
  if not test $last_status -eq 0
    set fish_prompt_status (set_color $fish_color_error)
  end
  if [ $USER != "armin" ]
    printf '%s%s%s@%s%s ' \
      $__fish_prompt_user $USER \
      $__fish_prompt_normal \
      $__fish_prompt_host $__fish_prompt_hostname
  end
  printf '%s%s%s%s%s> ' \
    $__fish_prompt_cwd (prompt_pwd) \
    $__fish_prompt_normal (__fish_git_prompt) \
    $fish_prompt_status 

  set_color normal
end
