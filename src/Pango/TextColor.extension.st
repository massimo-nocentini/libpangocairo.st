Extension { #name : #TextColor }

{ #category : #'*Pango' }
TextColor >> asPangoAttributeString [

	^ 'foreground #' , self color asHexString
]
