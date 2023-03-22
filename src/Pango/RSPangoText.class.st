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

	markup := anObject.

	self updateBaseRectangle
]

{ #category : #public }
RSPangoText >> translationPoint [

	^ 0 @ 0
]

{ #category : #accessing }
RSPangoText >> updateBaseRectangle [

	| fontDescription surface sizePoint |
	fontDescription := PangoFontDescription newFromString: 'Sans 12'.
	surface := AthensCairoSurface width: 500 height: 500.
	surface drawDuring: [ :canvas |
		| fontLayout |
		fontLayout := PangoLayout newCanvas: canvas.
		fontLayout fontDescription: fontDescription.
		fontLayout markup: (self markup ifNil: [ '' ]).

		canvas updateLayout: fontLayout.

		sizePoint := fontLayout size / 1024.0.

		self extent: sizePoint ]
]
