tell application "iTunes"
  set file_path to (POSIX file (item 1 of argv)) as string
  set added_track to add file_path
  set loc to (get location of added_track)
  convert added_track
  delete added_track

  tell application "Finder"
    delete loc
  end tell
end tell