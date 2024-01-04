Extension { #name : 'String' }

{ #category : '*LibPangoCairo' }
String >> asRSPangoShapeUsingFont: font [

	^ RSPangoMarkup new
		  font: font;
		  markup: self;
		  asCompositeShape
]

{ #category : '*LibPangoCairo' }
String >> shStyleElement [

	^ SHStyleElement withTokens: #( string )
]
