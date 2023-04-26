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
		'attributesChunks',
		'font',
		'defaultForegroundColor'
	],
	#category : #Pango
}

{ #category : #visiting }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : #accessing }
RSPangoText >> attributesChunks [

	^ attributesChunks
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

{ #category : #accessing }
RSPangoText >> font [

	^ font
]

{ #category : #accessing }
RSPangoText >> font: anObject [

	font := anObject
]

{ #category : #handle }
RSPangoText >> freeResource: pangoAttributeList ofPangoLayout: fontLayout [

	pangoAttributeList isNull ifFalse: [ pangoAttributeList unref ]
]

{ #category : #handle }
RSPangoText >> initPangoLayout: aPangoLayout [

	| attrSpec externalAddress chunks |
	aPangoLayout text: self text.

	chunks := OrderedCollection new
		          add:
			          '0 -1 foreground #'
			          , self defaultForegroundColor asHexString;
		          add: ('0 -1 font-desc "{1} {2}"' format: {
						           self font familyName.
						           self font pointSize });
		          addAll: self attributesChunks;
		          yourself.

	attrSpec := ', ' join: chunks.

	externalAddress := attrSpec asPangoAttrList.

	aPangoLayout set_attributes: externalAddress.

	^ externalAddress
]

{ #category : #initialization }
RSPangoText >> initialize [

	super initialize.

	self
		font: StandardFonts defaultFont;
		defaultForegroundColor: Smalltalk ui theme textColor;
		attributesChunks: OrderedCollection new
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
		| metricsProvider |
		metricsProvider := CairoFontMetricsProvider new
			                   font: self font;
			                   yourself.

		athensCanvas setScaledFont: metricsProvider cairoFont.

		self withAthensCairoCanvas: athensCanvas do: [ :pangoLayout |
			athensCanvas updateLayout: pangoLayout. ";
					             showLayout: pangoLayout"

			extent := pangoLayout logicalRectangle extent ] ].

	self
		extent: extent;
		signalUpdate
]

{ #category : #handle }
RSPangoText >> withAthensCairoCanvas: athensCanvas do: aBlock [

	| pangoLayout resource |
	pangoLayout := PangoLayout newCanvas: athensCanvas.

	resource := self initPangoLayout: pangoLayout.

	[ aBlock value: pangoLayout ] ensure: [
		self freeResource: resource ofPangoLayout: pangoLayout ]
]
