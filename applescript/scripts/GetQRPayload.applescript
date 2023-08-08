use framework "CoreImage"

on getQRPayload(imagePath)
	set theImage to current application's NSImage's alloc()'s initWithContentsOfFile:imagePath
	set theCIImage to current application's CIImage's imageWithData:(theImage's TIFFRepresentation())
	set theDetector to my (CIDetector's detectorOfType:(my CIDetectorTypeQRCode) context:(my CIContext's context()) 
options:(missing value))
	
	set theFeatures to theDetector's featuresInImage:theCIImage
	
	set theResult to ""
	repeat with theFeature in theFeatures
		set theResult to theResult & theFeature's messageString() & ", "
	end repeat
	
	if length of theResult > 0 then
		set theResult to text 1 thru ((length of theResult) - 2) of theResult
	end if
	return theResult
end getQRPayload

return getQRPayload("/Users/exampleUser/Downloads/image.png")
