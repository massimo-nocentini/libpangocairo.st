Extension { #name : 'TextColor' }

{ #category : '*LibPangoCairo' }
TextColor >> asPangoAttributeChunks: aFont [

	^ { ('foreground #' , self color asHexString) }
]
