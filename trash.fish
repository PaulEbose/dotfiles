function trash --description 'Move files to trash'
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Move files to trash"
        echo "trash [-h|--help] [ARGUMENTS...]"
        return 0
    end

    if test (count $argv) = 0
        echo "Move files to trash"
        echo "trash [-h|--help] [ARGUMENTS...]"
        return 0
    end

    set length 0
    set files

    for file in $argv
        command kioclient5 --noninteractive mv $file trash:/ &>/dev/null

        if test $status = 0
            set length (math $length + 1)
        else
            set -a files $file
        end
    end

    if not test (count $files) = 0
        if test (count $files) = 1
            set error 'Invalid path: ["'$files'"]'
        else
            set error 'Invalid paths: ["'(string join '", "' $files)'"]'
        end
        command notify-send -u critical -c Utility -a Trash $error
        echo $error
    end

    if test $length = 1
        set success (string join ' ' 'Moved' $length 'item to Trash')
    else
        set success (string join ' ' 'Moved' $length 'items to Trash')
    end
    echo $success
    command notify-send -u low -c Utility -a Trash $success
end
