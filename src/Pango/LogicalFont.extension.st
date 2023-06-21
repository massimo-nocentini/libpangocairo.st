Extension { #name : #LogicalFont }

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMonospacePointSize: size [

	^ self familyName: 'Source Code Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansPointSize: size [

	^ self familyName: 'Source Sans Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansSerifPointSize: size [

	^ self familyName: 'Source Serif Pro' pointSize: size
]
