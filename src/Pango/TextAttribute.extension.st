Extension { #name : #TextAttribute }

{ #category : #'*Pango' }
TextAttribute >> asPangoAttributeChunks: aFont [

	^ {  }
]

{ #category : #'*Pango' }
TextAttribute >> attributesForFont: aFont [

	^ {
		  ('family ' , aFont familyName)".
		  ('font-size ' , aFont pointSize asString)" }
]
