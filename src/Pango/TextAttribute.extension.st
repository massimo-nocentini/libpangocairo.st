Extension { #name : #TextAttribute }

{ #category : #'*Pango' }
TextAttribute >> asPangoAttributeChunks [

	^ {  }
]

{ #category : #'*Pango' }
TextAttribute >> attributesForFont: aFont [

	^ { ('font-desc "{1} {2}"' format: {
			   aFont familyName.
			   aFont pointSize }) }
]
