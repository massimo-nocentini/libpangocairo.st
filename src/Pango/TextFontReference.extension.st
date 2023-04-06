Extension { #name : #TextFontReference }

{ #category : #'*Pango' }
TextFontReference >> asPangoAttributeChunks [
	"Resend `attributesForFont:` from my parent class."

	^ self attributesForFont: self font
]
