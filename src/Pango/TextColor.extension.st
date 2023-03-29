Extension { #name : #TextColor }

{ #category : #'*Pango' }
TextColor >> asPangoAttributeString [

	^ self color name = 'unnamed'
		  ifTrue: [ '' ]
		  ifFalse: [ 'foreground ' , self color name ]
]
