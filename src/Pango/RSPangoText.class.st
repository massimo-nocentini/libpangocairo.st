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

	markup := anObject.

	self updateBaseRectangle
]

{ #category : #public }
RSPangoText >> translationPoint [

	^ 0 @ 0
]

{ #category : #accessing }
RSPangoText >> updateBaseRectangle [

	| fontDescription surface sizePoint font |
	font := StandardFonts defaultFont.

	fontDescription := PangoFontDescription newFromString:
		                   font familyName , ' ' , font pointSize asString.

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
