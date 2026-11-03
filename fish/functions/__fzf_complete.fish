function __fzf_complete -d "fzf-tab style completion: pick fish completions with fzf"
    set -l token (commandline -ct)

    # Inside an open quote fish's own completer handles escaping better
    if string match -qr '^["\']' -- $token
        commandline -f complete
        return
    end

    # Complete only what's left of the cursor, like native tab
    set -l candidates (complete -C -- (commandline -cp | string collect))
    test (count $candidates) -eq 0; and return

    set -l selected
    if test (count $candidates) -eq 1
        set selected $candidates
    else
        set -l fzf_args --height=~40% --layout=reverse --multi --ansi \
            --delimiter=\t --with-nth=2 --tiebreak=index --query=$token

        # Preview files/dirs with fzf.fish's helper when completing paths
        set -l first (string split -f1 \t -- $candidates[1])
        if test -e (string replace -r '^~' $HOME -- $first)
            set -a fzf_args --preview='_fzf_preview_file (string replace -r "^~" $HOME -- {1})' \
                --preview-window='right,50%,<80(hidden)'
        end

        # fzf-tab style lines: "value<pad> -- description", sorted alphabetically.
        # Field 1 keeps the raw value (hidden), field 2 is what fzf displays.
        set candidates (printf '%s\n' $candidates | command sort -f)
        set -l names (string split -f1 \t -- $candidates)
        set -l descs (string replace -r '^[^\t]*\t?' '' -- $candidates)
        set -l width (math "min(30, $(string length -V -- $names | command sort -n | tail -1))")
        set -l dim (set_color brblack)
        set -l normal (set_color normal)
        set -l lines
        for i in (seq (count $names))
            if test -n "$descs[$i]"
                set -a lines "$names[$i]"\t"$(string pad -r -w $width -- $names[$i])  $dim-- $descs[$i]$normal"
            else
                set -a lines "$names[$i]"\t"$names[$i]"
            end
        end
        set selected (
            printf '%s\n' $lines |
            SHELL=(status fish-path) fzf $fzf_args $fzf_complete_opts
        )
    end

    if test -n "$selected"
        set -l result
        for item in $selected
            set item (string split -f1 \t -- $item)
            # Escape spaces etc., but keep a leading ~ or $ live
            set -a result (string escape -n -- $item | string replace -r '^\\\\([~$])' '$1')
        end
        set result (string join ' ' -- $result)
        # No trailing space after a dir or `--opt=`, so you can keep typing
        string match -qr '[/=]$' -- $result; or set result "$result "
        commandline -rt -- $result
    end

    commandline -f repaint
end
