Extension { #name : #TextFontChange }

{ #category : #'*Pango' }
TextFontChange >> asPangoAttributeChunks [

	| font |
	font := TextStyle default fontAt: self fontNumber.

	^ self attributesForFont: font
]
