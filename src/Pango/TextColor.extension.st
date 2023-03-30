Extension { #name : #TextColor }

{ #category : #'*Pango' }
TextColor >> asPangoAttributeChunks [

	^ { ('foreground #' , self color asHexString) }
]
