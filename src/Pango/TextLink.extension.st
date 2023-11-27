Extension { #name : #TextLink }

{ #category : #'*Pango' }
TextLink >> asPangoAttributeChunks: aFont [

	^ self attributesForFont: StandardFonts codeFont
]
