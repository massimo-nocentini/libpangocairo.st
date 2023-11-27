Extension { #name : #UndefinedObject }

{ #category : #'*Pango' }
UndefinedObject >> appendCarriageReturnsOnStream: stream nextParagraph: micBlock [

	stream
		cr;
		cr
]

{ #category : #'*Pango' }
UndefinedObject >> shStyleElement [

	^ SHStyleElement withTokens: #( 'nil' )
]
