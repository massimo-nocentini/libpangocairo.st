Extension { #name : #TextEmphasis }

{ #category : #'*Pango' }
TextEmphasis >> asPangoAttributeString [

	^ self class bold emphasisCode == self emphasisCode
		  ifTrue: [ 'weight bold' ]
		  ifFalse: [ '' ]
]
