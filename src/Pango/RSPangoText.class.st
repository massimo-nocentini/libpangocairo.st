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
	#category : 'Pango',
	#package : 'Pango'
}

{ #category : 'visiting' }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : 'converting' }
RSPangoText >> asCompositeShape [

	^ RSComposite new
		  shapes: { self };
		  yourself
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

	| surface rectangle athensCanvas |
	"A very small surface to create an `AthensCairoCanvas` object."
	surface := self cairoImageSurfaceCreateWidth: 1 height: 1.

	athensCanvas := self cairo_create: surface.

	self
		onAthensCairoCanvas: athensCanvas
		withPangoLayoutDo: [ :layoutHandler |
			| originAndExtentPoints |
			originAndExtentPoints := self rectangleOfPangoLayoutHandler:
				                         layoutHandler.

			rectangle := Rectangle
				             origin: originAndExtentPoints first
				             extent: originAndExtentPoints second ].

	self
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
RSPangoText >> newPangoAttrListHandler [

	<primitive: 'primitive_pango_attr_list_new' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> newPangoLayoutOnAthensCairoCanvasHandler: cairoCanvas [

	<primitive: 'primitive_pango_cairo_create_layout' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'handle' }
RSPangoText >> onAthensCairoCanvas: athensCanvas withPangoLayoutDo: aBlock [

	| layoutHandler |
	layoutHandler := self newPangoLayoutOnAthensCairoCanvasHandler:
		                 athensCanvas getHandle.

	[
	self
		onPangoLayout: layoutHandler setWidth: self layoutWidth;
		onPangoLayout: layoutHandler setText: self text.

	self
		withPangoAttrListFromString: self pangoAttrListString
		do: [ :attrListHandler |
			self
				onPangoLayout: layoutHandler
				setAttrListHandler: attrListHandler.

			aBlock value: layoutHandler ] ] ensure: [
		self g_object_unref: layoutHandler ]
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

{ #category : 'handle' }
RSPangoText >> pangoAttrListString [

	| chunks |
	chunks := OrderedCollection new
		          add:
			          '0 -1 foreground #'
			          , self defaultForegroundColor asHexString;
		          add: ('0 -1 font-desc "{1}, Normal {2}"' format: {
						           self font familyName.
						           self font pointSize });
		          addAll: attributesChunks;
		          yourself.

	^ Character lf join: chunks
]

{ #category : 'ffi bindings' }
RSPangoText >> pangoAttrListUnref: handler [

	<primitive: 'primitive_pango_attr_list_unref' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'handle' }
RSPangoText >> rectangleOfPangoLayoutHandler: anHandler [

	<primitive: 'primitive_pango_layout_get_pixel_extents' module:
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
RSPangoText >> withPangoAttrListFromString: aString do: aBlock [

	| handler |
	handler := aString
		           ifEmpty: [ self newPangoAttrListHandler ]
		           ifNotEmpty: [
		           self pangoAttrListHandlerFromString: aString ].

	[ aBlock value: handler ] ensure: [ self pangoAttrListUnref: handler ]
]
