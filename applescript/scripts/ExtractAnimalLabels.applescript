use framework "Vision"

on getImageAnimals(imagePath)
  	-- Get image content
	set theImage to current application's NSImage's alloc()'s initWithContentsOfFile:imagePath
	
 	-- Set up request handler using image's raw data
	set requestHandler to current application's VNImageRequestHandler's alloc()'s initWithData:(theImage's 
TIFFRepresentation()) options:(current application's NSDictionary's alloc()'s init())
	
 	-- Initialize text request
	set theRequest to current application's VNRecognizeAnimalsRequest's alloc()'s init()
	
 	-- Perform the request and get the results
	requestHandler's performRequests:(current application's NSArray's arrayWithObject:(theRequest)) |error|:(missing 
value)
	set theResults to theRequest's results()
	
 	-- Obtain and return the string labels of the results
	set theAnimals to ""
	repeat with observation in theResults
		repeat with label in (observation's labels())
			set theAnimals to (theAnimals & label's identifier as text) & ", "
		end repeat
	end repeat
	return text 1 thru -3 of theAnimals
end getImageAnimals

return getImageAnimals("/Users/exampleUser/Documents/animals.png")
