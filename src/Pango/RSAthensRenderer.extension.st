Extension { #name : #RSAthensRenderer }

{ #category : #'*Pango' }
RSAthensRenderer >> visitPangoText: pango [

	| lbtranslation fontLayout |
	lbtranslation := (pango extent / 2.0) asFloatPoint negated.
	matrix translateBy: lbtranslation.
	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	fontLayout := PangoLayout newCanvas: athensCanvas.
	fontLayout markup: (pango markup ifNil: [ '' ]).

	athensCanvas
		updateLayout: fontLayout;
		showLayout: fontLayout.

	athensCanvas pathTransform translateBy: lbtranslation negated.
	athensCanvas setPathMatrix
]
