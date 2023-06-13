Extension { #name : #RSAthensRenderer }

{ #category : #'*Pango' }
RSAthensRenderer >> visitPangoText: pango [

	| lbtranslation |
	lbtranslation := (pango extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	pango withAthensCairoCanvas: athensCanvas do: [ :layoutHandler |
		athensCanvas
			updateLayout: layoutHandler;
			showLayout: layoutHandler ]
	"
	matrix translateBy: lbtranslation negated.
	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix"
]
