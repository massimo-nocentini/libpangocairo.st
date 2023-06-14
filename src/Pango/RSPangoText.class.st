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
	#name : #RSPangoText,
	#superclass : #RSBoundingShape,
	#instVars : [
		'text',
		'font',
		'defaultForegroundColor',
		'attributesChunks',
		'pangoContext',
		'layoutWidth'
	],
	#category : #Pango
}

{ #category : #visiting }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : #accessing }
RSPangoText >> attributesChunks: anObject [

	attributesChunks := anObject
]

{ #category : #accessing }
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

		self withAthensCairoCanvas: athensCanvas do: [ :layoutHandler |
			rectangle := self rectangleOfPangoLayoutHandler: layoutHandler ] ]
			ensure: [ scaledCairoFont unlock ] ].

	^ rectangle
]

{ #category : #'as yet unclassified' }
RSPangoText >> defaultFontMap [

	^ self
		  ffiCall: #( void * pango_cairo_font_map_get_default
			     #(  ) )
		  module: PangoCairoLibrary
]

{ #category : #accessing }
RSPangoText >> defaultForegroundColor [

	^ defaultForegroundColor
]

{ #category : #accessing }
RSPangoText >> defaultForegroundColor: anObject [

	defaultForegroundColor := anObject
]

{ #category : #accessing }
RSPangoText >> font [

	^ font
]

{ #category : #accessing }
RSPangoText >> font: anObject [

	font := anObject
]

{ #category : #initialization }
RSPangoText >> initialize [

	super initialize.

	pangoContext := self newPangoContext.

	self
		setPangoContextFontMap: self defaultFontMap;
		layoutWidthNiceColumns;
		font: StandardFonts defaultFont;
		defaultForegroundColor: Smalltalk ui theme textColor;
		attributesChunks: OrderedCollection new
]

{ #category : #accessing }
RSPangoText >> layoutWidth [

	^ layoutWidth = -1
		  ifTrue: [ layoutWidth ]
		  ifFalse: [ layoutWidth * 1024 ]
]

{ #category : #accessing }
RSPangoText >> layoutWidth: width [

	layoutWidth := width
]

{ #category : #accessing }
RSPangoText >> layoutWidthNiceColumns [

	self layoutWidth: (512 * Float goldenRatio) ceiling
]

{ #category : #accessing }
RSPangoText >> layoutWidthUnbounded [

	self layoutWidth: -1
]

{ #category : #'as yet unclassified' }
RSPangoText >> newPangoContext [

	^ self
		  ffiCall: #( void * pango_context_new #(  ) )
		  module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> newPangoLayout [

	^ self
		  ffiCall: #( void * pango_layout_new #( void * pangoContext ) )
		  module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> onPangoLayout: pangoHandler setAttrListHandler: attrListHander [

	self
		ffiCall: #( void pango_layout_set_attributes
			   #( void * pangoHandler , void * attrListHander ) )
		module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> onPangoLayout: pangoHandler setText: aString [

	^ self
		  ffiCall:
			  #( void pango_layout_set_text #( void * pangoHandler , const
			        char * aString , -1 ) )
		  module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> onPangoLayout: layout setWidth: width [

	^ self
		  ffiCall:
		  #( void pango_layout_set_width #( void * layout , int width ) )
		  module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> pangoAttrListFromString: aString [

	^ self
		  ffiCall:
		  #( void * pango_attr_list_from_string #( const char * aString ) )
		  module: PangoLibrary
]

{ #category : #handle }
RSPangoText >> pangoAttrListString [

	| chunks |
	chunks := OrderedCollection new
		          add:
			          '0 -1 foreground #'
			          , self defaultForegroundColor asHexString;
		          add: ('0 -1 font-desc "{1} {2}"' format: {
						           self font familyName.
						           self font pointSize });
		          addAll: attributesChunks;
		          yourself.

	^ Character lf join: chunks
]

{ #category : #'as yet unclassified' }
RSPangoText >> pangoAttrListUnref: handler [

	^ self
		  ffiCall: #( void pango_attr_list_unref #( void * handler ) )
		  module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> rectangleOfPangoLayoutHandler: anHandler [

	| liblua |
	liblua := LibLua uniqueInstance.

	^ liblua withOpenedLibsStateDo: [ :L |
		  | x y w h requestLogicalRectangle |
		  requestLogicalRectangle := true. "Ink rectangle otherwise."

		  liblua on: L assertLUAOK: [
			  liblua
				  luaL_requiref: L name: 'cairo';
				  on: L push: #cairo;
				  lua_getfield: L at: -1 name: 'pango_layout_get_extents';
				  on: L push: anHandler;
				  on: L push: requestLogicalRectangle;
				  lua_pcall: L nargs: 2 nresults: 4 ].

		  x := liblua on: L at: -4.
		  y := liblua on: L at: -3.
		  w := liblua on: L at: -2.
		  h := liblua on: L at: -1.

		  Rectangle origin: x @ y extent: w @ h ]
]

{ #category : #'as yet unclassified' }
RSPangoText >> setPangoContextFontMap: fontMap [

	^ self
		  ffiCall:
		  #( void pango_context_set_font_map #( void * pangoContext
		        , void * fontMap ) )
		  module: PangoLibrary
]

{ #category : #accessing }
RSPangoText >> text [

	^ text
]

{ #category : #accessing }
RSPangoText >> text: anObject [

	text := anObject
]

{ #category : #'*Pango' }
RSPangoText >> unrefPangoLayout: handler [

	self
		ffiCall: #( void g_object_unref #( void * handler ) )
		module: PangoLibrary
]

{ #category : #handle }
RSPangoText >> withAthensCairoCanvas: athensCanvas do: aBlock [

	athensCanvas updateContext: pangoContext.

	self withPangoLayoutHandler: [ :layoutHandler |
		self
			onPangoLayout: layoutHandler setWidth: self layoutWidth;
			onPangoLayout: layoutHandler setText: self text.

		self
			withPangoAttrListFromString: self pangoAttrListString
			do: [ :attrListHandler |
				self
					onPangoLayout: layoutHandler
					setAttrListHandler: attrListHandler.

				aBlock value: layoutHandler ] ]
]

{ #category : #'as yet unclassified' }
RSPangoText >> withPangoAttrListFromString: aString do: aBlock [

	| handler |
	handler := self pangoAttrListFromString: aString.

	[ aBlock value: handler ] ensure: [ self pangoAttrListUnref: handler ]
]

{ #category : #handle }
RSPangoText >> withPangoLayoutHandler: block [

	| layoutHandler |
	layoutHandler := self newPangoLayout.

	[ block value: layoutHandler ] ensure: [
		self unrefPangoLayout: layoutHandler ]
]
