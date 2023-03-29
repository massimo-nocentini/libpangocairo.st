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
		'attributesString'
	],
	#category : #Pango
}

{ #category : #visiting }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : #accessing }
RSPangoText >> attributesString [

	^ attributesString
]

{ #category : #accessing }
RSPangoText >> attributesString: anObject [

	attributesString := anObject
]

{ #category : #'as yet unclassified' }
RSPangoText >> freeResource: resource ofPangoLayout: fontLayout [

	fontLayout attr_list_unref: resource
]

{ #category : #'as yet unclassified' }
RSPangoText >> initPangoLayout: aPangoLayout [

	| attrSpec externalAddress |
	aPangoLayout text: self text.

	attrSpec := ', ' join: {'0 6 foreground black'} ,  self attributesString.
	
	externalAddress := aPangoLayout attributesString: attrSpec.

	aPangoLayout set_attributes: externalAddress.

	^ externalAddress
]

{ #category : #initialization }
RSPangoText >> initialize [

	super initialize.

	self attributesString: #(  )
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

	| surface sizePoint |
	surface := AthensCairoSurface width: 500 height: 500.

	surface drawDuring: [ :canvas |
		| fontLayout resource |
		fontLayout := PangoLayout newCanvas: canvas.

		resource := self initPangoLayout: fontLayout.

		canvas
			updateLayout: fontLayout;
			showLayout: fontLayout.

		self freeResource: resource ofPangoLayout: fontLayout.

		sizePoint := fontLayout logicalRectangle extent.

		self
			extent: sizePoint;
			signalUpdate ]
]
