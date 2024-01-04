Extension { #name : 'TextBackgroundColor' }

{ #category : '*LibPangoCairo' }
TextBackgroundColor >> asPangoAttributeChunks: aFont [

	^ { ('background #' , self color asHexString) }
]
