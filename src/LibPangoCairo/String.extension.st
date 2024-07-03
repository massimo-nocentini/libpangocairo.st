Extension { #name : 'String' }

{ #category : '*LibPangoCairo' }
String >> asRSPangoShapeUsingFont: font [

	^ RSPangoMarkup new
		  model: self;
		  font: font;
		  text: self;
		  yourself
]

{ #category : '*LibPangoCairo' }
String >> shStyleElement [

	^ SHStyleElement withTokens: #( string )
]
