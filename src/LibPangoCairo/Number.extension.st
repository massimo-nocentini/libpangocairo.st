Extension { #name : 'Number' }

{ #category : '*LibPangoCairo' }
Number >> defaultPangoFont [

	^ PangoLogicalFontManager pangoMath
]

{ #category : '*LibPangoCairo' }
Number >> shStyleElement [

	^ SHStyleElement withTokens: #( number )
]
