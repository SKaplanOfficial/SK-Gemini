use framework "Foundation"
use framework "PDFKit"

-- Load the PDF file as NSData
set thePDFFile to "/Users/exampleUser/Documents/example.pdf"
set pdfData to current application's NSData's dataWithContentsOfFile:thePDFFile

-- Create a PDFDocument from the PDF data
set pdfDoc to current application's PDFDocument's alloc()'s initWithData:pdfData

-- Flip each page horizontally
repeat with i from 0 to ((pdfDoc's pageCount()) - 1)
	set thePDFPage to (pdfDoc's pageAtIndex:i)
	set pdfRect to (thePDFPage's boundsForBox:(current application's kPDFDisplayBoxMediaBox))
	set flippedPdfImage to (current application's NSImage's alloc()'s initWithSize:(item 2 of pdfRect))
	
	flippedPdfImage's lockFocus()
	set transform to current application's NSAffineTransform's alloc()'s init()
	(transform's scaleXBy:-1 yBy:1)
	(transform's translateXBy:(-(item 1 of item 2 of pdfRect)) yBy:0)
	transform's concat()
	(thePDFPage's drawWithBox:(current application's kPDFDisplayBoxMediaBox))
	flippedPdfImage's unlockFocus()
	
	set newPage to (current application's PDFPage's alloc()'s initWithImage:flippedPdfImage)
	
	(pdfDoc's removePageAtIndex:i)
	(pdfDoc's insertPage:newPage atIndex:i)
end repeat

-- Write the modified PDF data to the disk
set flippedPdfData to pdfDoc's dataRepresentation()
flippedPdfData's writeToFile:thePDFFile atomically:true
