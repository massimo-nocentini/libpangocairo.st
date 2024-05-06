Class {
	#name : 'PangoCairoTestCase',
	#superclass : 'TestCase',
	#category : 'LibPangoCairo-Tests',
	#package : 'LibPangoCairo-Tests'
}

{ #category : 'tests' }
PangoCairoTestCase >> testSizeExtent [

	| surface rectangle extent athensCanvas pango |
	pango := RSPangoText new
		         text: 'hello world';
		         yourself.

	surface := pango cairoImageSurfaceCreateWidth: 1 height: 1.

	athensCanvas := pango cairo_create: surface.

	pango
		onAthensCairoCanvasHandle: athensCanvas
		withPangoLayoutHandleDo: [ :layout |
			extent := pango extentOfPangoLayoutHandle: layout.
			rectangle := pango
				             rectangleOfPangoLayoutHandle: layout
				             class: Rectangle ].

	pango
		cairo_destroy: athensCanvas;
		cairo_surface_destroy: surface.

	self assert: extent equals: rectangle extent.

	self assert: pango asCompositeShape extent equals: extent
]
