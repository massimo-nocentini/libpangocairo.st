"
logicalRectangle
	""Answer a Rectangle with the logical bounds.
	See https://docs.gtk.org/Pango/method.GlyphString.extents.html""

	| logicalRectangle inkRectangle |
	logicalRectangle := PangoRectangle externalNew.
	inkRectangle := PangoRectangle externalNew.

	self
		getExtentsInkRectangle: inkRectangle
		logicalRectangle: logicalRectangle.

	^ inkRectangle asRectangle

"
Class {
	#name : 'RSPangoText',
	#superclass : 'RSBoundingShape',
	#instVars : [
		'text',
		'font',
		'defaultForegroundColor',
		'attributesChunks',
		'layoutWidth'
	],
	#classVars : [
		'OriginPoint'
	],
	#category : 'LibPangoCairo',
	#package : 'LibPangoCairo'
}

{ #category : 'class initialization' }
RSPangoText class >> initialize [

	OriginPoint := 0 @ 0
]

{ #category : 'visiting' }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : 'converting' }
RSPangoText >> asMorph [

	| surface |
	surface := AthensCairoSurface
		           width: self encompassingRectangle width
		           height: self encompassingRectangle height.

	surface drawDuring: [ :cr |
		| layout pair attrsHandler |
		pair := self onAthensCairoCanvas: cr getHandle.

		layout := pair first.
		attrsHandler := pair second.

		self
			onAthensCairoCanvasHandler: cr getHandle
			showPangoLayout: layout.

		self
			pangoAttrListUnref: attrsHandler;
			g_object_unref: layout ].

	^ surface asForm asMorph
]

{ #category : 'accessing' }
RSPangoText >> attributesChunks: anObject [

	attributesChunks := anObject
]

{ #category : 'ffi bindings' }
RSPangoText >> cairoImageSurfaceCreateWidth: w height: h [

	<primitive: 'primitive_cairo_image_surface_create' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> cairo_create: surfaceExternalAddress [

	<primitive: 'primitive_cairo_create' module: 'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> cairo_destroy: surfaceExternalAddress [

	<primitive: 'primitive_cairo_destroy' module: 'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> cairo_surface_destroy: surfaceExternalAddress [

	<primitive: 'primitive_cairo_surface_destroy' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'accessing - computed' }
RSPangoText >> computeEncompassingRectangle [

	| surface rectangle athensCanvas layout pair attrsHandler extent |
	"A very small surface to create an `AthensCairoCanvas` object."
	surface := self cairoImageSurfaceCreateWidth: 1 height: 1.

	athensCanvas := self cairo_create: surface.

	pair := self onAthensCairoCanvas: athensCanvas.

	layout := pair first.
	attrsHandler := pair second.

	extent := self rectangleOfPangoLayoutHandler: layout.

	rectangle := Rectangle center: OriginPoint extent: extent.

	self
		pangoAttrListUnref: attrsHandler;
		g_object_unref: layout;
		cairo_destroy: athensCanvas;
		cairo_surface_destroy: surface.

	^ rectangle
]

{ #category : 'accessing' }
RSPangoText >> defaultForegroundColor [

	^ defaultForegroundColor
]

{ #category : 'accessing' }
RSPangoText >> defaultForegroundColor: anObject [

	defaultForegroundColor := anObject
]

{ #category : 'accessing' }
RSPangoText >> font [

	^ font
]

{ #category : 'accessing' }
RSPangoText >> font: anObject [

	font := anObject
]

{ #category : 'ffi bindings' }
RSPangoText >> g_object_unref: handler [

	<primitive: 'primitive_g_object_unref' module: 'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'initialization' }
RSPangoText >> initialize [

	super initialize.

	self
		layoutWidthUnbounded;
		font: StandardFonts defaultFont;
		defaultForegroundColor: Smalltalk ui theme textColor;
		attributesChunks: OrderedCollection new
]

{ #category : 'accessing' }
RSPangoText >> layoutWidth [

	^ layoutWidth
]

{ #category : 'accessing' }
RSPangoText >> layoutWidth: width [

	layoutWidth := width
]

{ #category : 'accessing' }
RSPangoText >> layoutWidthNiceColumns [

	self layoutWidth: (1024 * Float silverRatio) ceiling
]

{ #category : 'accessing' }
RSPangoText >> layoutWidthUnbounded [

	self layoutWidth: -1
]

{ #category : 'ffi bindings' }
RSPangoText >> newPangoLayoutOnAthensCairoCanvasHandler: cairoCanvas [

	<primitive: 'primitive_pango_cairo_create_layout' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'handle' }
RSPangoText >> onAthensCairoCanvas: athensCanvas [

	| layoutHandler attrsHandler |
	layoutHandler := self newPangoLayoutOnAthensCairoCanvasHandler:
		                 athensCanvas.

	self
		onPangoLayout: layoutHandler setWidth: self layoutWidth;
		onPangoLayout: layoutHandler setText: self text.

	attrsHandler := self withPangoAttrList.

	self onPangoLayout: layoutHandler setAttrListHandler: attrsHandler.

	^ {
		  layoutHandler.
		  attrsHandler }
]

{ #category : 'ffi bindings' }
RSPangoText >> onAthensCairoCanvasHandler: cairoCanvas showPangoLayout: layout [

	<primitive: 'primitive_pango_cairo_show_layout' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> onPangoLayout: pangoHandler setAttrListHandler: attrListHander [

	<primitive: 'primitive_pango_layout_set_attributes' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> onPangoLayout: pangoHandler setText: aString [

	<primitive: 'primitive_pango_layout_set_text' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> onPangoLayout: layout setWidth: width [

	<primitive: 'primitive_pango_layout_set_width' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> pangoAttrListHandlerFromString: aString [

	<primitive: 'primitive_pango_attr_list_from_string' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> pangoAttrListUnref: handler [

	<primitive: 'primitive_pango_attr_list_unref' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'handle' }
RSPangoText >> rectangleOfPangoLayoutHandler: anHandler [

	<primitive: 'primitive_pango_layout_get_ink_pixel_size' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'accessing' }
RSPangoText >> text [

	^ text
]

{ #category : 'accessing' }
RSPangoText >> text: anObject [

	text := anObject
]

{ #category : 'handle' }
RSPangoText >> withPangoAttrList [

	^ self pangoAttrListHandlerFromString:
		  (String streamContents: [ :stream |
			   stream
				   nextPutAll: '0 -1 foreground #';
				   nextPutAll: self defaultForegroundColor asHexString;
				   lf;
				   nextPutAll: '0 -1 font-desc "';
				   nextPutAll: self font familyName;
				   nextPutAll: ', Normal ';
				   nextPutAll: self font pointSize asString;
				   nextPutAll: '"'.

			   attributesChunks do: [ :each |
				   stream
					   lf;
					   nextPutAll: each ] ])
]
