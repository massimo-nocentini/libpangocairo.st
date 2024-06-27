Extension { #name : 'RSAthensRenderer' }

{ #category : '*LibPangoCairo' }
RSAthensRenderer >> visitGdkPixbuf: gdkPixbufShape [

	self visitShapeIfNecessary: gdkPixbufShape block: [
		| point |
		point := athensCanvas getCurrentPoint
		         - gdkPixbufShape extent halvedAsFloat.

		athensCanvas
			gdkCairoSetSourcePixbuf: gdkPixbufShape getHandle
			x: point x
			y: point y.

		athensCanvas primPaint ]
]

{ #category : '*LibPangoCairo' }
RSAthensRenderer >> visitPangoText: pangoShape [

	self
		visitShape: pangoShape
		withScaledMatrixDo: [
		pangoShape showLayoutOnAthensCairoCanvas: athensCanvas ]
]
