Extension { #name : #TextBackgroundColor }

{ #category : #'*Pango' }
TextBackgroundColor >> asPangoAttributeChunks: aFont [

	^ { 'underline single' } "('background #' , self color asHexString)"
]
