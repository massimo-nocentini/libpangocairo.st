Extension { #name : 'TextLink' }

{ #category : '*LibPangoCairo' }
TextLink >> asPangoAttributeChunks: aFont [

	^ self attributesForFont: StandardFonts codeFont
]
