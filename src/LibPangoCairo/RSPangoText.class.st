"
# Intro

[Text Attributes and markup](https://docs.gtk.org/Pango/pango_markup.html)
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
		'LastSmalltalkSession',
		'LayoutForExtents',
		'OriginPoint'
	],
	#category : 'LibPangoCairo-Roassal',
	#package : 'LibPangoCairo',
	#tag : 'Roassal'
}

{ #category : 'class initialization' }
RSPangoText class >> initialize [

	OriginPoint := 0 @ 0.
	LastSmalltalkSession := Smalltalk session
]

{ #category : 'visiting' }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : 'converting' }
RSPangoText >> asMorph [

	| surface |
	surface := AthensCairoSurface width: self width height: self height.

	surface drawDuring: [ :cr | self showLayoutOnAthensCairoCanvas: cr ].

	^ surface asForm asMorph
]

{ #category : 'converting' }
RSPangoText >> asPresenter [

	^ SpAthensPresenter new
		  extent: self extent;
		  surfaceExtent: self extent;
		  drawBlock: [ :aCanvas :boundingBox | self showLayoutOnAthensCairoCanvas: aCanvas ];
		  yourself
]

{ #category : 'accessing' }
RSPangoText >> attributesChunks: anObject [

	attributesChunks := anObject
]

{ #category : 'accessing' }
RSPangoText >> baseRectangle [

	baseRectangle := self text
		                 ifNil: [ OriginPoint corner: OriginPoint ]
		                 ifNotNil: [
			                 self
				                 onPangoLayoutHandle: self layoutForExtents
				                 withAttributesDo: [ :layout |
					                 | extent |
					                 extent := self extentOfPangoLayoutHandle: layout.
					                 Rectangle extentCenteredAtCartesianOrigin:
						                 extent ] ].

	^ super baseRectangle
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

{ #category : 'defaults' }
RSPangoText >> defaultExtent [

	^ OriginPoint
]

{ #category : 'accessing' }
RSPangoText >> defaultForegroundColor [

	^ defaultForegroundColor
]

{ #category : 'accessing' }
RSPangoText >> defaultForegroundColor: anObject [

	defaultForegroundColor := anObject
]

{ #category : 'handle' }
RSPangoText >> extentOfPangoLayoutHandle: anHandler [

	<primitive: 'primitive_pango_layout_get_pixel_size' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'accessing' }
RSPangoText >> font [

	^ font
]

{ #category : 'accessing' }
RSPangoText >> font: anObject [

	font := anObject
]

{ #category : 'accessing' }
RSPangoText >> g_object_unref: handler [

	<primitive: 'primitive_g_object_unref' module: 'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'initialization' }
RSPangoText >> initialize [

	self
		layoutWidthUnbounded;
		font: PangoLogicalFontManager pangoSerif;
		defaultForegroundColor: Smalltalk ui theme textColor;
		attributesChunks: OrderedCollection new.

	super initialize
]

{ #category : 'accessing' }
RSPangoText >> layoutForExtents [

	(Smalltalk session ~~ LastSmalltalkSession or: [
		 LayoutForExtents isNil ]) ifTrue: [
		| surface athensCanvas |
		surface := self cairoImageSurfaceCreateWidth: 1 height: 1.
		athensCanvas := self cairo_create: surface.
		LayoutForExtents := self
			                    newPangoLayoutHandleOnAthensCairoCanvasHandle:
			                    athensCanvas
		"self
				cairo_destroy: athensCanvas;
				cairo_surface_destroy: surface" ].

	^ LayoutForExtents
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
RSPangoText >> newPangoLayoutHandleOnAthensCairoCanvasHandle: cairoCanvas [

	<primitive: 'primitive_pango_cairo_create_layout' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'ffi bindings' }
RSPangoText >> onAthensCairoCanvasHandle: cairoCanvas showPangoLayout: layout [

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

{ #category : 'handle' }
RSPangoText >> onPangoLayoutHandle: layoutHandler withAttributesDo: block [

	| attrsHandler |
	self
		onPangoLayout: layoutHandler setWidth: self layoutWidth;
		onPangoLayout: layoutHandler setText: self text.

	attrsHandler := self withPangoAttrList.

	self onPangoLayout: layoutHandler setAttrListHandler: attrsHandler.

	^ [ block value: layoutHandler ] ensure: [
		  self pangoAttrListUnref: attrsHandler ]
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
RSPangoText >> rectangleOfPangoLayoutHandle: anHandler class: aClass [

	<primitive: 'primitive_pango_layout_get_pixel_extents' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'converting' }
RSPangoText >> showLayoutOnAthensCairoCanvas: anAthensCairoCanvas [

	self
		onPangoLayoutHandle: anAthensCairoCanvas pangoLayoutHandle
		withAttributesDo: [ :layout |
			self
				onAthensCairoCanvasHandle: anAthensCairoCanvas getHandle
				showPangoLayout: layout ]
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

	| stylesString |
	stylesString := String streamContents: [ :stream |
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
				                nextPutAll: each ] ].

	^ self pangoAttrListHandlerFromString: stylesString
]
