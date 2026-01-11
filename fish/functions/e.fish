function e --description 'Smart file handler - edit, execute, or open based on file type'
    if test (count $argv) -eq 0
        echo "Usage: e <file>"
        return 1
    end

    set -l file $argv[1]

    if not test -e "$file"
        echo "File not found: $file"
        return 1
    end

    # Handle directories - open in nvim
    if test -d "$file"
        nvim "$file"
        return 0
    end

    # Handle files by extension
    switch $file
        # Scripts - execute
        case '*.py'
            python "$file"
        case '*.sh'
            bash "$file"
        case '*.fish'
            fish "$file"
        case '*.js'
            node "$file"
        case '*.rb'
            ruby "$file"
        case '*.pl'
            perl "$file"
        case '*.go'
            go run "$file"
        case '*.rs'
            rustc "$file" -o /tmp/rust_output && /tmp/rust_output

        # Data formats - pretty print
        case '*.json'
            if command -v jq &> /dev/null
                jq . "$file" | bat -l json
            else
                bat -l json "$file"
            end
        case '*.yaml' '*.yml'
            if command -v yq &> /dev/null
                yq . "$file" | bat -l yaml
            else
                bat -l yaml "$file"
            end
        case '*.csv'
            if command -v csvlook &> /dev/null
                csvlook "$file" | bat
            else
                bat "$file"
            end
        case '*.xml'
            if command -v xmllint &> /dev/null
                xmllint --format "$file" | bat -l xml
            else
                bat -l xml "$file"
            end

        # Archives - list contents or extract
        case '*.tar.gz' '*.tgz' '*.tar.bz2' '*.tbz2' '*.tar.xz' '*.txz' '*.zip' '*.rar' '*.7z'
            echo "Archive file detected. Extract? (y/N)"
            read -l response
            if test "$response" = "y" -o "$response" = "Y"
                extract "$file"
            else
                # List contents
                switch $file
                    case '*.zip'
                        unzip -l "$file"
                    case '*.tar.*' '*.tgz' '*.tbz2' '*.txz'
                        tar -tvf "$file"
                    case '*.rar'
                        unrar l "$file"
                    case '*.7z'
                        7z l "$file"
                end
            end

        # Images - open with system viewer
        case '*.png' '*.jpg' '*.jpeg' '*.gif' '*.bmp' '*.svg' '*.webp' '*.ico'
            open "$file"

        # PDFs and documents - open with system viewer
        case '*.pdf'
            open "$file"
        case '*.doc' '*.docx' '*.xls' '*.xlsx' '*.ppt' '*.pptx'
            open "$file"

        # Media files - open with system player
        case '*.mp4' '*.mkv' '*.avi' '*.mov' '*.wmv' '*.flv' '*.webm'
            open "$file"
        case '*.mp3' '*.wav' '*.flac' '*.ogg' '*.m4a' '*.aac'
            open "$file"

        # Binary/compiled files - inspect
        case '*.exe' '*.dll' '*.so' '*.dylib' '*.bin'
            echo "Binary file. Show file info:"
            file "$file"
            echo ""
            echo "Show strings? (y/N)"
            read -l response
            if test "$response" = "y" -o "$response" = "Y"
                strings "$file" | bat
            end

        # Log files - tail with follow
        case '*.log'
            echo "Log file. View options:"
            echo "  1) View entire file (bat)"
            echo "  2) Tail last 50 lines"
            echo "  3) Tail and follow"
            echo "  4) Edit in nvim"
            read -l choice
            switch $choice
                case 1
                    bat "$file"
                case 2
                    tail -n 50 "$file" | bat
                case 3
                    tail -f "$file"
                case 4
                    nvim "$file"
                case '*'
                    bat "$file"
            end

        # Markdown - edit
        case '*.md' '*.markdown'
            nvim "$file"

        # Code and text files - edit
        case '*.txt' '*.conf' '*.cfg' '*.ini' '*.env' '*.properties'
            nvim "$file"
        case '*.c' '*.h' '*.cpp' '*.hpp' '*.cc' '*.cxx'
            nvim "$file"
        case '*.java' '*.class' '*.jar'
            nvim "$file"
        case '*.ts' '*.tsx' '*.jsx'
            nvim "$file"
        case '*.php' '*.html' '*.css' '*.scss' '*.sass' '*.less'
            nvim "$file"
        case '*.vim' '*.lua' '*.el' '*.clj' '*.lisp'
            nvim "$file"
        case '*.tf' '*.tfvars' '*.hcl'
            nvim "$file"
        case '*.dockerfile' 'Dockerfile*' '*.containerfile'
            nvim "$file"
        case 'Makefile' '*.mk' 'Rakefile' 'Gemfile'
            nvim "$file"

        # Default - try to determine by content
        case '*'
            # Check if it's a text file
            if file "$file" | grep -q text
                nvim "$file"
            else
                # Binary file - show info and ask
                echo "Unknown file type:"
                file "$file"
                echo ""
                echo "Open with system default? (y/N)"
                read -l response
                if test "$response" = "y" -o "$response" = "Y"
                    open "$file"
                else
                    echo "Use: bat, nvim, or hexdump? [b/n/h]"
                    read -l tool
                    switch $tool
                        case b
                            bat "$file"
                        case n
                            nvim "$file"
                        case h
                            hexdump -C "$file" | bat
                        case '*'
                            echo "Cancelled"
                    end
                end
            end
    end
end
