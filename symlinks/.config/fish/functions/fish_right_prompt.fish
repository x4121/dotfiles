function fish_right_prompt
  set -l last_status $status
  set_color $fish_color_error
  if not test $last_status -eq 0
    echo -n $last_status ''
  end
end
