Extension { #name : 'String' }

{ #category : '*Pango' }
String >> asRSPangoShapeUsingFont: font [

	^ RSPangoMarkup new
		  font: font;
		  markup: self;
		  asCompositeShape
]

{ #category : '*Pango' }
String >> shStyleElement [

	^ SHStyleElement withTokens: #( string )
]
