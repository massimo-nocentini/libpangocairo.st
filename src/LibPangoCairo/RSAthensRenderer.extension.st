Extension { #name : 'RSAthensRenderer' }

{ #category : '*LibPangoCairo' }
RSAthensRenderer >> visitGdkPixbuf: gdkPixbufShape [

	| lbtranslation cPoint |
	lbtranslation := gdkPixbufShape extent halvedAsFloat negated.

	matrix translateBy: lbtranslation.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	cPoint := athensCanvas getCurrentPoint.

	athensCanvas
		gdkCairoSetSourcePixbuf: gdkPixbufShape getHandle
		x: cPoint x
		y: cPoint y;
		primPaint
]

{ #category : '*LibPangoCairo' }
RSAthensRenderer >> visitPangoText: pangoShape [

	matrix translateBy: pangoShape extent halvedAsFloat negated.

	athensCanvas pathTransform loadAffineTransform: matrix.
	athensCanvas setPathMatrix.

	(pangoShape paint asAthensPaintOn: athensCanvas) loadOnCairoCanvas:
		athensCanvas.

	pangoShape showLayoutOnAthensCairoCanvas: athensCanvas
]
