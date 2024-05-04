Extension { #name : 'RSAthensRenderer' }

{ #category : '*LibPangoCairo' }
RSAthensRenderer >> visitPangoText: pangoShape [

	| lbtranslation cairo_tHandle |
	lbtranslation := (pangoShape extent / 2.0) asFloatPoint negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	(pangoShape paint asAthensPaintOn: athensCanvas) loadOnCairoCanvas:
		athensCanvas.

	cairo_tHandle := athensCanvas getHandle.

	pangoShape
		onAthensCairoCanvas: cairo_tHandle
		do: [ :layout :attrsHandler |
			pangoShape
				onAthensCairoCanvasHandler: cairo_tHandle
				showPangoLayout: layout ]
]
