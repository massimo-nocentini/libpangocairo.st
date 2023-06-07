Extension { #name : #WriteStream }

{ #category : #'*Pango' }
WriteStream >> contentsFrom: from to: to [

	^ collection copyFrom: from to: to
]
