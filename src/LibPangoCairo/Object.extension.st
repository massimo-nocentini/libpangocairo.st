Extension { #name : 'Object' }

{ #category : '*LibPangoCairo' }
Object >> fullPangoPrintString [

	^ self fullPrintString
]

{ #category : '*LibPangoCairo' }
Object >> shStyleElement [

	^ SHStyleElement withTokens: #( default )
]
