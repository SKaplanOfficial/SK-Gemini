use framework "Foundation"
use framework "Quartz"

on applyComicEffect(sourcePath, destinationPath)
	set theImage to current application's NSImage's alloc()'s initWithContentsOfFile:sourcePath
	
	-- Set up the Filter
	set filterName to "CIComicEffect"
	set theFilter to current application's CIFilter's filterWithName:filterName
	theFilter's setDefaults()
	
	-- Convert NSImage to CIImage for use in Quartz functions
	set theCIImage to current application's CIImage's imageWithData:(theImage's TIFFRepresentation())
	theFilter's setValue:theCIImage forKey:"inputImage"
	
	-- Get result & crop to original image size
	set theBounds to current application's NSMakeRect(0, 0, theImage's |size|()'s width, theImage's |size|()'s 
height)
	set uncroppedOutput to theFilter's valueForKey:(current application's kCIOutputImageKey)
	set croppedOutput to uncroppedOutput's imageByCroppingToRect:theBounds
	
	-- Convert back to NSImage and save to file
	set theRep to current application's NSCIImageRep's imageRepWithCIImage:croppedOutput
	set theResult to current application's NSImage's alloc()'s initWithSize:(theRep's |size|())
	theResult's addRepresentation:theRep
	saveImage(theResult, destinationPath)
end applyComicEffect

on saveImage(imageToSave, destinationPath)
	set theTIFFData to imageToSave's TIFFRepresentation()
	set theBitmapImageRep to current application's NSBitmapImageRep's imageRepWithData:theTIFFData
	set theImageProperties to current application's NSDictionary's dictionaryWithObject:1 forKey:(current 
application's NSImageCompressionFactor)
	set theResultData to theBitmapImageRep's representationUsingType:(current application's NSPNGFileType) 
|properties|:(missing value)
	theResultData's writeToFile:destinationPath atomically:false
end saveImage

applyComicEffect("/Users/exampleUser/Desktop/image.png", "/Users/exampleUser/Desktop/image.png")
