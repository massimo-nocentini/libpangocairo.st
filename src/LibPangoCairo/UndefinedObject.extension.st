Extension { #name : 'UndefinedObject' }

{ #category : '*LibPangoCairo' }
UndefinedObject >> appendCarriageReturnsOnStream: stream nextParagraph: micBlock [

	stream
		cr;
		cr
]

{ #category : '*LibPangoCairo' }
UndefinedObject >> shStyleElement [

	^ SHStyleElement withTokens: #( 'nil' )
]
