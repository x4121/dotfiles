function fish_user_key_bindings
  fzf_key_bindings

  # Bind EscEsc to thefuck
  bind \e\e 'thefuck-command-line'

  # Bind Alt+t to font_toggle
  bind \et font_toggle.sh
end
