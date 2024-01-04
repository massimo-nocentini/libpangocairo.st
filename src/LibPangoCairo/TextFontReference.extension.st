Extension { #name : 'TextFontReference' }

{ #category : '*LibPangoCairo' }
TextFontReference >> asPangoAttributeChunks: aFont [
	"Resend `attributesForFont:` from my parent class."

	^ self attributesForFont: self font
]
