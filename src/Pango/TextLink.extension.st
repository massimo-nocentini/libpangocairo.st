Extension { #name : #TextLink }

{ #category : #'*Pango' }
TextLink >> asPangoAttributeChunks [

	^ self attributesForFont: StandardFonts codeFont
]
