Extension { #name : 'TextFontChange' }

{ #category : '*Pango' }
TextFontChange >> asPangoAttributeChunks: aFont [

	| font |
	font := aFont textStyle fontAt: self fontNumber.

	^ self attributesForFont: font
]
