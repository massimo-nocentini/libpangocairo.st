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

{ #category : 'accessing' }
RSPangoText >> attributesChunks: anObject [

	attributesChunks := anObject
]

{ #category : 'accessing' }
RSPangoText >> computeEncompassingRectangle [

	| surface rectangle |
	"A very small surface to create an `AthensCairoCanvas` object."
	surface := AthensCairoSurface width: 1 height: 1.

	surface drawDuring: [ :athensCanvas |
		| scaledCairoFont |
		scaledCairoFont := CairoScaledFont fromFreetypeFont:
			                   self font asFreetypeFont.

		scaledCairoFont lock.

		[
		athensCanvas setScaledFont: scaledCairoFont.

		self
			onAthensCairoCanvas: athensCanvas
			withPangoLayoutDo: [ :layoutHandler |
				rectangle := self rectangleOfPangoLayoutHandler: layoutHandler ] ]
			ensure: [ scaledCairoFont unlock ] ].

	^ rectangle
]

{ #category : 'ffi bindings' }
RSPangoText >> defaultFontMap [

	^ self
		  ffiCall: #( void * pango_cairo_font_map_get_default
			     #(  ) )
		  module: PangoCairoLibrary
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

	self
		ffiCall: #( void g_object_unref #( void #* handler ) )
		module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> getContextOfPangoLayout: layout [

	^ self
		  ffiCall: #( void * pango_layout_get_context
		     #( void * layout ) )
		  module: PangoLibrary
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

	^ self
		  ffiCall: #( void * pango_attr_list_new #(  ) )
		  module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> newPangoContext [

	^ self
		  ffiCall: #( void * pango_context_new #(  ) )
		  module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> newPangoLayout [

	^ self
		  ffiCall: #( void * pango_layout_new #( void * pangoContext ) )
		  module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> newPangoLayoutOnAthensCairoCanvasHandler: cairoCanvas [

	self
		ffiCall:
		#( void * pango_cairo_create_layout #( void * cairoCanvas ) )
		module: PangoCairoLibrary
]

{ #category : 'handle' }
RSPangoText >> onAthensCairoCanvas: athensCanvas withPangoLayoutDo: aBlock [

	| layoutHandler ensuredBlock |
	layoutHandler := self newPangoLayoutOnAthensCairoCanvasHandler:
		                 athensCanvas getHandle.

	ensuredBlock := [
	                self
		                onPangoLayout: layoutHandler
		                setWidth: self layoutWidth;
		                onPangoLayout: layoutHandler setText: self text.

	                self
		                withPangoAttrListFromString:
		                self pangoAttrListString
		                do: [ :attrListHandler |
			                self
				                onPangoLayout: layoutHandler
				                setAttrListHandler: attrListHandler.

			                aBlock value: layoutHandler ] ].

	ensuredBlock ensure: [ self g_object_unref: layoutHandler ]
]

{ #category : 'ffi bindings' }
RSPangoText >> onAthensCairoCanvasHandler: cairoCanvas showPangoLayout: layout [

	self
		ffiCall:
		#( void pango_cairo_show_layout #( void * cairoCanvas , void * layout ) )
		module: PangoCairoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> onPangoLayout: pangoHandler setAttrListHandler: attrListHander [

	self
		ffiCall: #( void pango_layout_set_attributes
			   #( void * pangoHandler , void * attrListHander ) )
		module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> onPangoLayout: pangoHandler setText: aString [

	^ self
		  ffiCall:
			  #( void pango_layout_set_text #( void * pangoHandler , const
			        char * aString , -1 ) )
		  module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> onPangoLayout: layout setWidth: width [

	^ self
		  ffiCall:
		  #( void pango_layout_set_width #( void * layout , int width ) )
		  module: PangoLibrary
]

{ #category : 'ffi bindings' }
RSPangoText >> pangoAttrListHandlerFromString: aString [

	^ self
		  ffiCall:
		  #( void * pango_attr_list_from_string #( const char * aString ) )
		  module: PangoLibrary
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

	^ self
		  ffiCall: #( void pango_attr_list_unref #( void * handler ) )
		  module: PangoLibrary
]

{ #category : 'handle' }
RSPangoText >> rectangleOfPangoLayoutHandler: anHandler [

	| liblua |
	liblua := LibLua uniqueInstance implementationPrimitive.

	^ liblua withOpenedLibsStateDo: [ :L |
		  | x y w h requestLogicalRectangle |
		  requestLogicalRectangle := true. "Ink rectangle otherwise."

		  liblua on: L assertLUAOK: [
			  liblua
				  luaL_requiref: L name: 'cairo';
				  on: L push: #cairo;
				  lua: L get: -1 field: 'pango_layout_get_extents';
				  on: L push: anHandler;
				  on: L push: requestLogicalRectangle;
				  lua_pcall: L nargs: 2 nresults: 4 ].

		  x := liblua on: L at: -4.
		  y := liblua on: L at: -3.
		  w := liblua on: L at: -2.
		  h := liblua on: L at: -1.

		  Rectangle origin: x @ y extent: w @ h ]
]

{ #category : 'ffi bindings' }
RSPangoText >> setPangoContextFontMap: fontMap [

	^ self
		  ffiCall:
		  #( void pango_context_set_font_map #( void * pangoContext
		        , void * fontMap ) )
		  module: PangoLibrary
]

{ #category : 'accessing' }
RSPangoText >> text [

	^ text
]

{ #category : 'accessing' }
RSPangoText >> text: anObject [

	text := anObject
]

{ #category : 'ffi bindings' }
RSPangoText >> updatePangoContextOnAthensCairoCanvas: cairoCanvas [

	self
		ffiCall:
		#( void pango_cairo_update_context #( void * cairoCanvas , void * pangoContext ) )
		module: PangoCairoLibrary
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
