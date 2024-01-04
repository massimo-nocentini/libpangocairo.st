Extension { #name : 'TextAttribute' }

{ #category : '*LibPangoCairo' }
TextAttribute >> asPangoAttributeChunks: aFont [

	^ {  }
]

{ #category : '*LibPangoCairo' }
TextAttribute >> attributesForFont: aFont [

	^ {
		  ('family ' , aFont familyName)".
		  ('font-size ' , aFont pointSize asString)" }
]
