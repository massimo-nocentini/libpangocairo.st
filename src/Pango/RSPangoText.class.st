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
		'markup'
	],
	#category : #Pango
}

{ #category : #visiting }
RSPangoText >> accept: visitor [

	visitor visitPangoText: self
]

{ #category : #accessing }
RSPangoText >> markup [

	^ markup
]

{ #category : #accessing }
RSPangoText >> markup: anObject [

	markup := Character cr join:
		          (anObject lines collect: [ :aString |
			           aString ifEmpty: [ ' ' ] ]).


	self updateBaseRectangle
]

{ #category : #accessing }
RSPangoText >> updateBaseRectangle [

	| surface sizePoint |
	surface := AthensCairoSurface width: 500 height: 500.

	surface drawDuring: [ :canvas |
		| fontLayout |
		fontLayout := PangoLayout newCanvas: canvas.
		"fontLayout fontDescription: fontDescription."
		fontLayout markup: (self markup ifNil: [ '<span></span>' ]).

		canvas
			updateLayout: fontLayout;
			showLayout: fontLayout.

		sizePoint := fontLayout logicalRectangle extent.

		self
			extent: sizePoint;
			signalUpdate ]
]
