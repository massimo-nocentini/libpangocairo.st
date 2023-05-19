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
RSPangoWithAttrList >> initPangoLayout: aPangoLayout [

	| attrSpec chunks |
	chunks := OrderedCollection new
		          add:
			          '0 -1 foreground #'
			          , self defaultForegroundColor asHexString;
		          add: ('0 -1 font-desc "{1} {2}"' format: {
						           self font familyName.
						           self font pointSize });
		          addAll: self attributesChunks;
		          yourself.

	attrSpec := String lf join: chunks.

	^ PangoAttrList attr_list_from_string: attrSpec
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

	| surface extent |
	"A very small surface to create an `AthensCairoCanvas` object."
	surface := AthensCairoSurface width: 1 height: 1.

	surface drawDuring: [ :athensCanvas |
		| metricsProvider |
		metricsProvider := CairoFontMetricsProvider new
			                   font: self font;
			                   yourself.

		athensCanvas setScaledFont: metricsProvider cairoFont.

		self
			withAthensCairoCanvas: athensCanvas
			do: [ :pangoLayout | extent := pangoLayout logicalRectangle extent ] ].

	self
		extent: extent;
		signalUpdate
]

{ #category : #handle }
RSPangoWithAttrList >> withAthensCairoCanvas: athensCanvas do: aBlock [

	| pangoLayout pangoAttrList |
	pangoLayout := PangoLayout newCanvas: athensCanvas.

	pangoAttrList := self initPangoLayout: pangoLayout.

	pangoLayout
		text: self text;
		set_attributes: pangoAttrList.

	[ aBlock value: pangoLayout ] ensure: [
		pangoAttrList unref.
		pangoLayout unref ]
]
