Extension { #name : 'RSAthensRenderer' }

{ #category : '*Pango' }
RSAthensRenderer >> visitPangoText: pangoShape [

	| lbtranslation layout |
	lbtranslation := (pangoShape extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	layout := pangoShape
		          onAthensCairoCanvas: athensCanvas getHandle
		          withPangoLayoutDo: [ :layoutHandler |
			          pangoShape
				          onAthensCairoCanvasHandler: athensCanvas getHandle
				          showPangoLayout: layoutHandler ].

	pangoShape g_object_unref: layout
]
