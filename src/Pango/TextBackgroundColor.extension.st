Extension { #name : #TextBackgroundColor }

{ #category : #'*Pango' }
TextBackgroundColor >> asPangoAttributeChunks [

	^ { ('background #' , self color asHexString) }
]
