Extension { #name : #RSAthensRenderer }

{ #category : #'*Pango' }
RSAthensRenderer >> visitPangoText: pangoShape [

	| lbtranslation layout pair attrsHandler |
	lbtranslation := (pangoShape extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	pair := pangoShape onAthensCairoCanvas: athensCanvas getHandle.

	layout := pair first.
	attrsHandler := pair second.

	pangoShape
		onAthensCairoCanvasHandler: athensCanvas getHandle
		showPangoLayout: layout.

	pangoShape
		pangoAttrListUnref: attrsHandler;
		g_object_unref: layout
]
