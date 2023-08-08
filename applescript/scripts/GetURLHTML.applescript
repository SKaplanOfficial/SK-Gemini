use framework "Foundation"

set theResult to ""
on getURLHTML(theURL)
	global theResult
	set theURL to current application's NSURL's URLWithString:theURL
	set theSessionConfiguration to current application's NSURLSessionConfiguration's defaultSessionConfiguration()
	set theSession to current application's NSURLSession's sessionWithConfiguration:(theSessionConfiguration) 
delegate:(me) delegateQueue:(missing value)
	set theRequest to current application's NSURLRequest's requestWithURL:theURL
	set theTask to theSession's dataTaskWithRequest:theRequest
	theTask's resume()
	
	set completedState to current application's NSURLSessionTaskStateCompleted
	set canceledState to current application's NSURLSessionTaskStateCanceling
	
	repeat while theTask's state() is not completedState and theTask's state() is not canceledState
		delay 0.1
	end repeat
	
	return theResult
end getURLHTML

on URLSession:tmpSession dataTask:tmpTask didReceiveData:tmpData
	global theResult
	set theText to (current application's NSString's alloc()'s initWithData:tmpData encoding:(current application's 
NSASCIIStringEncoding)) as string
	set theResult to theResult & theText
end URLSession:dataTask:didReceiveData:

return getURLHTML("https://google.com")
