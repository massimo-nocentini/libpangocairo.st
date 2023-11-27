Extension { #name : #Object }

{ #category : #'*Pango' }
Object >> fullPangoPrintString [

	^ self fullPrintString
]

{ #category : #'*Pango' }
Object >> shStyleElement [

	^ SHStyleElement withTokens: #( default )
]
