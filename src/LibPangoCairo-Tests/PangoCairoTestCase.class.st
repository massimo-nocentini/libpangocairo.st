Class {
	#name : 'PangoCairoTestCase',
	#superclass : 'TestCase',
	#category : 'LibPangoCairo-Tests',
	#package : 'LibPangoCairo-Tests'
}

{ #category : 'tests' }
PangoCairoTestCase >> testSizeExtent [

	| surface rectangle extent athensCanvas pangoShape pangoLayoutHandle |
	pangoShape := RSPangoText new
		              text: 'hello world';
		              yourself.

	surface := pangoShape cairoImageSurfaceCreateWidth: 1 height: 1.

	athensCanvas := pangoShape cairo_create: surface.

	pangoLayoutHandle := pangoShape
		                     newPangoLayoutHandleOnAthensCairoCanvasHandle:
		                     athensCanvas.

	pangoShape
		onPangoLayoutHandle: pangoLayoutHandle
		withAttributesDo: [ :layout |
			extent := pangoShape extentOfPangoLayoutHandle: layout.
			rectangle := pangoShape
				             rectangleOfPangoLayoutHandle: layout
				             class: Rectangle ].

	pangoShape
		g_object_unref: pangoLayoutHandle;
		cairo_destroy: athensCanvas;
		cairo_surface_destroy: surface.

	self assert: extent equals: rectangle extent.

	self assert: pangoShape asCompositeShape extent equals: extent
]
