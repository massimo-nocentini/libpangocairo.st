Extension { #name : #RSAthensRenderer }

{ #category : #'*Pango' }
RSAthensRenderer >> visitPangoText: pango [

	| lbtranslation fontLayout resource |
	lbtranslation := (pango extent / 2.0) asFloatPoint negated.
	matrix translateBy: lbtranslation.
	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	fontLayout := PangoLayout newCanvas: athensCanvas.

	resource := pango initPangoLayout: fontLayout.

	athensCanvas
		updateLayout: fontLayout;
		showLayout: fontLayout.

	pango freeResource: resource ofPangoLayout: fontLayout.

	athensCanvas pathTransform translateBy: lbtranslation negated.
	athensCanvas setPathMatrix
]
