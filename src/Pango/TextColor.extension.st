Extension { #name : 'TextColor' }

{ #category : '*Pango' }
TextColor >> asPangoAttributeChunks: aFont [

	^ { ('foreground #' , self color asHexString) }
]
