Extension { #name : #TextBackgroundColor }

{ #category : #'*Pango' }
TextBackgroundColor >> asPangoAttributeChunks: aFont [

	^ { ('background #' , self color asHexString) }
]
