Extension { #name : #TextEmphasis }

{ #category : #'*Pango' }
TextEmphasis >> asPangoAttributeChunks [

	^ self emphasisCode = self class bold emphasisCode
		  ifTrue: [ { 'weight bold' } ]
		  ifFalse: [
			  self emphasisCode = self class italic emphasisCode
				  ifTrue: [ { 'style italic' } ]
				  ifFalse: [ { 'style normal' } ] ]
]
