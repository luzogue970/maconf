if status is-interactive
    # Commands to run in interactive sessions can go here
end
export EDITOR=vim
export VISUAL=vim

function fish_command_not_found
    set cmd $argv[1]
    set opt $argv[2]
    set lastarg $argv[-1]


    if test "$lastarg" != "-c"
        echo "⚠️ Command not found: $argv — searching for folder..."
        set cmd (string replace -r '/$' '' -- $cmd)

        set path (sudo find /home/mathieulp/Documents/ -type d -path "*/$cmd" -print -quit 2>/dev/null)
        if test "$path" = ""; or test "$opt" = "home"
            set path (sudo find /home -type d -path "*/$cmd" -print -quit 2>/dev/null)
        end
                if test "$path" = ""; or test "$opt" = "all"
            set path (sudo find / -type d -path "*/$cmd" -print -quit 2>/dev/null)
        end
        if test -n "$path"
            echo "📂 Found: $path"
                if test "$lastarg" = "c"
                cd "$path" && code . && exit
                return
                end
            cd "$path"
        else
            echo "❌ No folder found for: $cmd default handling..."
            /usr/libexec/pk-command-not-found $argv
        end
        return
    end
    /usr/libexec/pk-command-not-found $argv
end


fish_add_path -a "/home/mathieulp/.foundry/bin"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"
