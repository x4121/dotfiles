function fish_user_key_bindings
    fzf_key_bindings

    # Bind Alt+s to AWS profile selection
    bind \es '
    assume --ex
    set -x AWS_SDK_LOAD_CONFIG 1;
    set -x AWS_DEFAULT_REGION eu-central-1;
    set -x AWS_DEFAULT_PROFILE $AWS_PROFILE;
    '
end
