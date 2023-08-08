use framework "AppKit"

on getDataURIForImage:theNSImage
	-- Gets the image/png data URI of an NSImage
	set theTIFFData to theNSImage's TIFFRepresentation()
	set theBitmap to my (NSBitmapImageRep's imageRepWithData:(theTIFFData))
	set thePNGData to theBitmap's representationUsingType:(my NSJPEGFileType) |properties|:(missing value)
	return "data:" & "image/png" & ";base64," & (thePNGData's base64EncodedStringWithOptions:0) as text
end getDataURIForImage:

on imageWithSymbol:theSymbolName ofSize:theImageSize
	-- Gets the system symbol with the specified name, scaled to the provided size
	set config to my (NSImageSymbolConfiguration's configurationWithPointSize:theImageSize weight:(my 
NSFontWeightRegular))
	set theSymbol to my (NSImage's imageWithSystemSymbolName:theSymbolName accessibilityDescription:(missing value))
	return theSymbol's imageWithSymbolConfiguration:config
end imageWithSymbol:ofSize:

set theSymbol to my imageWithSymbol:"doc.text.below.ecg" ofSize:128
set theDataURI to my getDataURIForImage:theSymbol
return theDataURI
