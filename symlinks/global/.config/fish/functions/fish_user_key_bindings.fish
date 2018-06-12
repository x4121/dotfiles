function fish_user_key_bindings
  fzf_key_bindings

  # Bind EscEsc to thefuck
  bind \e\e 'thefuck-command-line'

  # Bind Alt+s to fzf-sts
  bind \es 'eval (fastsar)'
end
