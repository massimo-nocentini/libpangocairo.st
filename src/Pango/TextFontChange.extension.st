Extension { #name : #TextFontChange }

{ #category : #'*Pango' }
TextFontChange >> asPangoAttributeChunks [

	| logicalFont |
	logicalFont := TextStyle default fontAt: self fontNumber.

	^ { "'family Monospace'" }
]
