Extension { #name : 'RSAthensRenderer' }

{ #category : '*LibPangoCairo' }
RSAthensRenderer >> visitPangoText: pangoShape [

	matrix translateBy: pangoShape extent halvedAsFloat negated.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	(pangoShape paint asAthensPaintOn: athensCanvas) loadOnCairoCanvas:
		athensCanvas.

	pangoShape showLayoutOnAthensCairoCanvas: athensCanvas
]
