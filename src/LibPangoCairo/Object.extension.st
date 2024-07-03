Extension { #name : 'Object' }

{ #category : '*LibPangoCairo' }
Object >> defaultPangoFont [

	^ PangoLogicalFontManager pangoMonospace
]

{ #category : '*LibPangoCairo' }
Object >> fullPangoPrintString [

	^ self fullPrintString
]

{ #category : '*LibPangoCairo' }
Object >> shStyleElement [

	^ SHStyleElement withTokens: #( default )
]
