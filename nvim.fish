function nvim
    set doppler_config_path ~/.doppler/.doppler.yaml
    set nvim_path $(which nvim)
    set current_dir (pwd)
    set use_doppler_run false

    if test -f $doppler_config_path
        if not command -v yq > /dev/null 2>&1
            echo "Error: yq not found. Please install yq"
            return 1
        end

        set scoped_paths (yq eval '.scoped | to_entries | .[] | .key' $doppler_config_path)

        for path in $scoped_paths
            if string match -q -- "$path*" $current_dir
                if not string match -q -- "/" $path
                    set use_doppler_run true
                    break
                end
            end
        end
    end

    if $use_doppler_run
        doppler run -- nvim $argv
    else
        $nvim_path $argv
    end
end
