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
		'attributesChunks'
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

{ #category : #handle }
RSPangoText >> freeResource: externalAddress ofPangoLayout: fontLayout [

	externalAddress isNull ifFalse: [
		fontLayout attr_list_unref: externalAddress ]
]

{ #category : #handle }
RSPangoText >> initPangoLayout: aPangoLayout [

	| attrSpec externalAddress |
	aPangoLayout text: self text.

	attrSpec := ', ' join: self attributesChunks.

	externalAddress := aPangoLayout attr_list_from_string: attrSpec.

	aPangoLayout set_attributes: externalAddress.

	^ externalAddress
]

{ #category : #initialization }
RSPangoText >> initialize [

	super initialize.

	self attributesChunks: {  }
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
	surface := AthensCairoSurface width: 1 height: 1.

	surface drawDuring: [ :athensCanvas |
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
