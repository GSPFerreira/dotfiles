function backup
  if test -z "$argv"
    echo "Usage: backup <file>"
    return 1
  end

  if not test -e "$argv"
    echo "File not found: $argv"
    return 1
  end

  set backup_name "$argv.bak"
  cp -r "$argv" "$backup_name"
  echo "Backed up to: $backup_name"
end
