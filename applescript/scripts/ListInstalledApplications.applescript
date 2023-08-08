use framework "Foundation"

property ca : current application
property theResult : ""
property query : missing value

try
    set result to ""
    ca's NSNotificationCenter's defaultCenter's addObserver:me selector:"queryDidFinish:" |name|:"NSMetadataQueryDidFinishGatheringNotification" object:(missing value)
    set predicate to ca's NSPredicate's predicateWithFormat:"kMDItemContentType == 'com.apple.application-bundle'"
    set query to ca's NSMetadataQuery's alloc()'s init()
    query's setPredicate:predicate
    query's setSearchScopes:["/Applications", "/Users/"]
    query's startQuery()
    
    repeat while theResult is ""
    delay 0.1
    end repeat
    
    return text 1 thru ((length of theResult) - 2) of theResult
end try

on queryDidFinish:theNotification
    global result
    set queryResults to theNotification's object()'s results()
    set internalResult to ""
    repeat with object in queryResults
    set itemName to (object's valueForAttribute:("kMDItemFSName")) as text
    set appName to (text 1 thru ((length of itemName) - 4) of itemName)
    if appName does not contain "." and appName does not contain "_" and appName does not end with "Agent" and appName does not end with "Assistant" then
        set internalResult to internalResult & appName & ", "
    end if
    end repeat
    set theResult to internalResult
end queryDidFinish: