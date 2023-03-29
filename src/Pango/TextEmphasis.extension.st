Extension { #name : #TextEmphasis }

{ #category : #'*Pango' }
TextEmphasis >> asPangoAttributeString [

	^ self emphasisCode = 1
		  ifTrue: [ 'weight bold' ]
		  ifFalse: [ 'weight normal' ]
]
