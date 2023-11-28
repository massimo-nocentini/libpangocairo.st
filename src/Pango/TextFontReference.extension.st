Extension { #name : 'TextFontReference' }

{ #category : '*Pango' }
TextFontReference >> asPangoAttributeChunks: aFont [
	"Resend `attributesForFont:` from my parent class."

	^ self attributesForFont: self font
]
