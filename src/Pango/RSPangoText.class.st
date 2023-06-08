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
		'attributesChunks'
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
RSPangoText >> defaultForegroundColor [

	^ defaultForegroundColor
]

{ #category : #accessing }
RSPangoText >> defaultForegroundColor: anObject [

	defaultForegroundColor := anObject
]

{ #category : #'as yet unclassified' }
RSPangoText >> extentOfPangoLayoutHandler: anHandler [

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

		  (Rectangle origin: x @ y extent: w @ h) extent ]
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

	self
		font: StandardFonts defaultFont;
		defaultForegroundColor: Smalltalk ui theme textColor;
		attributesChunks: OrderedCollection new
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
RSPangoText >> setAttrListHandler: attrListHander onPangoHandler: pangoHandler [

	self
		ffiCall: #( void pango_layout_set_attributes
			   #( void * pangoHandler , void * attrListHander ) )
		module: PangoLibrary
]

{ #category : #'as yet unclassified' }
RSPangoText >> setText: aString onPangoHandler: pangoHandler [

	^ self
		  ffiCall:
			  #( void pango_layout_set_text #( void * pangoHandler , const
			        char * aString , -1 ) )
		  module: PangoLibrary
]

{ #category : #accessing }
RSPangoText >> text [

	^ text
]

{ #category : #accessing }
RSPangoText >> text: anObject [

	text := anObject.

	self updateBaseRectangle
]

{ #category : #accessing }
RSPangoText >> updateBaseRectangle [

	| surface extent |
	"A very small surface to create an `AthensCairoCanvas` object."
	surface := AthensCairoSurface width: 1 height: 1.

	surface drawDuring: [ :athensCanvas |
		| scaledCairoFont |
		scaledCairoFont := CairoScaledFont fromFreetypeFont:
			                   self font asFreetypeFont.
		athensCanvas setScaledFont: scaledCairoFont.

		self withAthensCairoCanvas: athensCanvas do: [ :pangoLayout |
			extent := self extentOfPangoLayoutHandler: pangoLayout ] ].

	self
		extent: extent;
		signalUpdate
]

{ #category : #handle }
RSPangoText >> withAthensCairoCanvas: athensCanvas do: aBlock [

	athensCanvas withPangoLayoutHandler: [ :layoutHandler |
		self
			withPangoAttrListFromString: self pangoAttrListString
			do: [ :attrListHandler | "Set the bare bone text on the Pango layout."
				self setText: self text onPangoHandler: layoutHandler.

				self
					setAttrListHandler: attrListHandler
					onPangoHandler: layoutHandler.

				aBlock value: layoutHandler ] ]
]

{ #category : #'as yet unclassified' }
RSPangoText >> withPangoAttrListFromString: aString do: aBlock [

	| handler |
	handler := self pangoAttrListFromString: aString.

	[ aBlock value: handler ] ensure: [ self pangoAttrListUnref: handler ]
]
