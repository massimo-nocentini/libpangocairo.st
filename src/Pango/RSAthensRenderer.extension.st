Extension { #name : #RSAthensRenderer }

{ #category : #'*Pango' }
RSAthensRenderer >> visitPangoText: pango [

	| lbtranslation |
	lbtranslation := (pango extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	pango withAthensCairoCanvas: athensCanvas do: [ :pangoLayout |
		| fontDescription |
		fontDescription := PangoFontDescription newFromString: 'Ubuntu Mono'.

		pangoLayout set_font_description: fontDescription.

		athensCanvas
			updateLayout: pangoLayout;
			showLayout: pangoLayout ].

	athensCanvas pathTransform translateBy: lbtranslation negated
]
