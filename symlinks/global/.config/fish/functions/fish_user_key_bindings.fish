function fish_user_key_bindings
  fzf_key_bindings

  # Bind Alt+s to AWS profile selection
  bind \es '
    set_color green;
    set -x AWS_SDK_LOAD_CONFIG 1;
    set -x AWS_DEFAULT_REGION eu-central-1;
    set -x AWS_PROFILE (aws configure list-profiles | fzf);
    and echo "Using profile $AWS_PROFILE";
    set_color normal;
    '
end
