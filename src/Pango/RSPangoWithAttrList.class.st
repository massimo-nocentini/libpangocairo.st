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
		'defaultForegroundColor',
		'liblua'
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

{ #category : #handle }
RSPangoWithAttrList >> attrlistSpecString [

	| chunks |
	chunks := OrderedCollection new
		          add:
			          '0 -1 foreground #'
			          , self defaultForegroundColor asHexString;
		          add: ('0 -1 font-desc "{1} {2}"' format: {
						           self font familyName.
						           self font pointSize });
		          addAll: self attributesChunks;
		          yourself.

	^ String lf join: chunks
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

{ #category : #initialization }
RSPangoWithAttrList >> initialize [

	super initialize.

	liblua := LibLua uniqueInstance.

	self
		font: StandardFonts defaultFont;
		defaultForegroundColor: Smalltalk ui theme textColor
]

{ #category : #handle }
RSPangoWithAttrList >> rectangleOnCairoCanvas: athensCanvas shouldShow: aBoolean [

	^ liblua withOpenedLibsStateDo: [ :L |
		  | x y w h |
		  liblua on: L assertLUAOK: [
			  liblua
				  luaL_requiref: L name: 'cairo';
				  on: L push: #cairo;
				  lua_getfield: L at: -1 name: 'pango_text_with_attrlist_spec';
				  on: L push: athensCanvas;
				  on: L push: self text;
				  on: L push: self attrlistSpecString;
				  on: L push: aBoolean;
				  lua_pcall: L nargs: 4 nresults: 4 ].

		  x := liblua on: L at: -4.
		  y := liblua on: L at: -3.
		  w := liblua on: L at: -2.
		  h := liblua on: L at: -1.

		  Rectangle center: x @ y extent: w @ h ]
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

		rect := self rectangleOnCairoCanvas: athensCanvas shouldShow: false ].

	self
		extent: rect extent;
		signalUpdate
]
