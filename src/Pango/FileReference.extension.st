Extension { #name : #FileReference }

{ #category : #'*Pango' }
FileReference >> asGroupOfPdfPages [

	^ RSPdf allPagesOfFileReference: self
]
