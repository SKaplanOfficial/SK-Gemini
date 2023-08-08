tell application "System Events"
	set theProcess to first application process whose name is "ControlCenter"
	click menu bar item 2 of menu bar 1 of theProcess
	perform action 1 of button 1 of group 1 of window 1 of theProcess
end tell
