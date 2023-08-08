use framework "Foundation"

(*
	Gets a record of information contain in a plist file.
	
	Params:
		thePath (String) - Path to the plist file.
		
	Returns:
		(Record) - The property:value pairs in the plist.
*)
on plist for thePath
	set plistData to current application's NSData's dataWithContentsOfFile:thePath
	set plist to (current application's NSPropertyListSerialization's propertyListWithData:plistData options:(current 
application's NSPropertyListImmutable) format:(missing value) |error|:(missing value)) as record
end plist

(*
	Constructs a list of bookmarks URLs recursively.
	
	Params:
		node (Record) - The current node of a plist structure.
		
	Returns:
		(List) - The list of bookmark URLs as strings.
*)
on getChildBookmarks(node)
	set internalBookmarks to {}
	if WebBookmarkType of node is "WebBookmarkTypeLeaf" then
		set maxLength to 50
		set theURL to URLString of node as text
		if length of theURL < maxLength then
			set maxLength to length of theURL
		end if
		copy text 1 thru maxLength of theURL to end of internalBookmarks
	else if WebBookmarkType of node is "WebBookmarkTypeProxy" then
		-- Ignore
	else
		try
			repeat with theChild in Children of node
				set internalBookmarks to internalBookmarks & my getChildBookmarks(theChild)
			end repeat
		on error err
			log err -- Empty bookmarks folder
		end try
	end if
	return internalBookmarks
end getChildBookmarks

-- Get the home directory for the current user
tell application "System Events"
	set homeDir to POSIX path of home folder
end tell

set bookmarksPlist to (plist for homeDir & "/Library/Safari/Bookmarks.plist")
return getChildBookmarks(bookmarksPlist)
