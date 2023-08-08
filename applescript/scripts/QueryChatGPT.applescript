use framework "Foundation"

property ca : current application

set theResult to ""
on queryChatGPT(query, openAIKey)
	global theResult
	set APIEndpoint to "https://api.openai.com/v1/chat/completions"
	set theURL to ca's NSURL's URLWithString:APIEndpoint
	
	-- Set up request headers
	set request to ca's NSMutableURLRequest's requestWithURL:theURL
	request's setHTTPMethod:"POST"
	request's setValue:"application/json" forHTTPHeaderField:"Content-Type"
	request's setValue:("Bearer " & openAIKey) forHTTPHeaderField:"Authorization"
	
	-- Create the request body as a dictionary
	set messageDict to ca's NSDictionary's dictionaryWithObjects:["user", query] forKeys:["role", "content"]
	set requestBody to ca's NSDictionary's dictionaryWithObjects:["gpt-3.5-turbo", {messageDict}, 0.7] 
forKeys:["model", "messages", "temperature"]
	
	-- Convert the request body to JSON data
	set requestBodyData to ca's NSJSONSerialization's dataWithJSONObject:requestBody options:0 |error|:(missing 
value)
	
	-- Set the request body data
	request's setHTTPBody:requestBodyData
	
	-- Create the session and task
	set config to ca's NSURLSessionConfiguration's defaultSessionConfiguration()
	set session to ca's NSURLSession's sessionWithConfiguration:config delegate:me delegateQueue:(missing value)
	set theTask to session's dataTaskWithRequest:request
	
	-- Start the task
	theTask's resume()
	
	set completedState to ca's NSURLSessionTaskStateCompleted
	set canceledState to ca's NSURLSessionTaskStateCanceling
	repeat while theTask's state() is not completedState and theTask's state() is not canceledState
		delay 0.1
	end repeat
	
	return theResult
end queryChatGPT

on URLSession:tmpSession dataTask:tmpTask didReceiveData:tmpData
	global theResult
	set theResponse to ca's NSJSONSerialization's JSONObjectWithData:tmpData options:0 |error|:(missing value)
	set theResult to ((((first item of (theResponse's objectForKey:("choices")))'s objectForKey:"message")'s 
objectForKey:"content") as text)
end URLSession:dataTask:didReceiveData:

set openAIKey to "YOUR_API_KEY_HERE"
set query to "What is the capital of Spain?"
queryChatGPT(query, openAIKey)
