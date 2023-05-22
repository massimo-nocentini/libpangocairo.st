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
	#name : #RSPangoWithAttrList,
	#superclass : #RSBoundingShape,
	#instVars : [
		'text',
		'font',
		'defaultForegroundColor'
	],
	#category : #Pango
}

{ #category : #visiting }
RSPangoWithAttrList >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : #accessing }
RSPangoWithAttrList >> attributesChunks [

	self subclassResponsibility
]

{ #category : #accessing }
RSPangoWithAttrList >> defaultForegroundColor [

	^ defaultForegroundColor
]

{ #category : #accessing }
RSPangoWithAttrList >> defaultForegroundColor: anObject [

	defaultForegroundColor := anObject
]

{ #category : #accessing }
RSPangoWithAttrList >> font [

	^ font
]

{ #category : #accessing }
RSPangoWithAttrList >> font: anObject [

	font := anObject
]

{ #category : #handle }
RSPangoWithAttrList >> initPangoLayout: chunks [

	chunks
		add: '0 -1 foreground #' , self defaultForegroundColor asHexString;
		add: ('0 -1 font-desc "{1} {2}"' format: {
						 self font familyName.
						 self font pointSize });
		addAll: self attributesChunks;
		yourself.

	^ String lf join: chunks
]

{ #category : #initialization }
RSPangoWithAttrList >> initialize [

	super initialize.

	self
		font: StandardFonts defaultFont;
		defaultForegroundColor: Smalltalk ui theme textColor
]

{ #category : #accessing }
RSPangoWithAttrList >> text [

	^ text
]

{ #category : #accessing }
RSPangoWithAttrList >> text: anObject [

	text := anObject.

	self updateBaseRectangle
]

{ #category : #accessing }
RSPangoWithAttrList >> updateBaseRectangle [

	| surface rect |
	"A very small surface to create an `AthensCairoCanvas` object."
	surface := AthensCairoSurface width: 1 height: 1.

	surface drawDuring: [ :athensCanvas |
		| metricsProvider |
		metricsProvider := CairoFontMetricsProvider new
			                   font: self font;
			                   yourself.

		athensCanvas setScaledFont: metricsProvider cairoFont.

		rect := self withAthensCairoCanvas: athensCanvas do: false ].

	self
		extent: rect extent;
		signalUpdate
]

{ #category : #handle }
RSPangoWithAttrList >> withAthensCairoCanvas: athensCanvas do: aBoolean [

	| pangoAttrListStringSpec ll |
	pangoAttrListStringSpec := self initPangoLayout:
		                           OrderedCollection new.

	ll := LibLua uniqueInstance.

	^ ll withOpenedLibsStateDo: [ :L |
		  | flag x y w h |
		  flag := ll
			          luaL_requiref: L name: 'cairo';
			          on: L push: #cairo;
			          lua_getfield: L at: -1 name: 'write';
			          on: L push: athensCanvas;
			          on: L push: self text;
			          on: L push: pangoAttrListStringSpec;
			          on: L push: aBoolean;
			          lua_pcall: L nargs: 4 nresults: 4.

		  self assert: flag = ll LUA_OK description: 'something'.

		  x := ll on: L at: -4.
		  y := ll on: L at: -3.
		  w := ll on: L at: -2.
		  h := ll on: L at: -1.

		  Rectangle center: x @ y extent: w @ h ]
]
