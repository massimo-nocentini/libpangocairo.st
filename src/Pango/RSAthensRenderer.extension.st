Extension { #name : #RSAthensRenderer }

{ #category : #'*Pango' }
RSAthensRenderer >> visitPangoText: pangoShape [

	| lbtranslation |
	lbtranslation := (pangoShape extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	pangoShape
		onAthensCairoCanvas: athensCanvas
		withPangoLayoutDo: [ :layoutHandler |
			pangoShape
				onAthensCairoCanvasHandler: athensCanvas getHandle
				showPangoLayout: layoutHandler ]
]

{ #category : #'*Pango' }
RSAthensRenderer >> visitPdf: pdfShape [

	| lbtranslation |
	lbtranslation := (pdfShape extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	pdfShape drawOnAthensCairoCanvas: athensCanvas
]
