Extension { #name : #FileReference }

{ #category : #'*Pango' }
FileReference >> asPdf [

	^ RSPdf new
		  fileReference: self;
		  yourself
]
