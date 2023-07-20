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
