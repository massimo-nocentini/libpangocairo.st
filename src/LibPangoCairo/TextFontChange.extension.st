Extension { #name : 'TextFontChange' }

{ #category : '*LibPangoCairo' }
TextFontChange >> asPangoAttributeChunks: aFont [

	| font |
	font := aFont textStyle fontAt: self fontNumber.

	^ self attributesForFont: font
]
