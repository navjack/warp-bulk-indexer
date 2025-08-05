on run argv
	-- Open a directory in a new Warp tab
	-- Usage: osascript open_dir_in_warp.scpt "/path/to/directory"
	
	if (count of argv) < 1 then
		error "Usage: osascript open_dir_in_warp.scpt \"/path/to/directory\""
	end if
	
	set targetDir to item 1 of argv
	
	-- Activate Warp (works with both stable and preview versions)
	try
		tell application "Warp" to activate
	on error
		try
			tell application "WarpPreview" to activate
		on error
			error "Neither Warp nor WarpPreview is installed or accessible"
		end try
	end try
	
	delay 0.2 -- give Warp a moment to focus
	
	tell application "System Events"
		-- Open a new tab
		keystroke "t" using {command down}
		delay 0.1
		-- Navigate to the directory and clear the screen
		keystroke "cd " & quoted form of targetDir & "; clear" & return
	end tell
end run
