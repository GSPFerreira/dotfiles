function extract
  if test -z "$argv"
    echo "Usage: extract <file>"
    return 1
  end

  if not test -f "$argv"
    echo "File not found: $argv"
    return 1
  end

  switch "$argv"
    case '*.tar.gz' '*.tgz'
      tar -xzf "$argv"
    case '*.tar.bz2' '*.tbz2'
      tar -xjf "$argv"
    case '*.tar.xz' '*.txz'
      tar -xJf "$argv"
    case '*.tar'
      tar -xf "$argv"
    case '*.zip'
      unzip "$argv"
    case '*.gz'
      gunzip "$argv"
    case '*.bz2'
      bunzip2 "$argv"
    case '*.rar'
      unrar x "$argv"
    case '*.7z'
      7z x "$argv"
    case '*'
      echo "Unknown archive format: $argv"
      return 1
  end
end
