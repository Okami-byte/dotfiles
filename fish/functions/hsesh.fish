function hsesh --description 'Wrapper around the herdr-sesh plugin binary (herdr equivalent of sesh)'
    if not set -q __hsesh_bin
        set -l plugin_root (herdr plugin list --plugin fullerzz.sesh --json | jq -r '.result.plugins[0].plugin_root')
        if test -z "$plugin_root" -o "$plugin_root" = null
            echo "hsesh: fullerzz.sesh herdr plugin not found" >&2
            return 1
        end
        set -g __hsesh_bin "$plugin_root/bin/herdr-sesh"
        set -gx HERDR_PLUGIN_CONFIG_DIR (herdr plugin config-dir fullerzz.sesh)
    end

    "$__hsesh_bin" $argv
end
