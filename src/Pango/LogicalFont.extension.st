Extension { #name : #LogicalFont }

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoFamilyName: familyName pointSize: size [

	^ self familyName: '' , familyName pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMonospacePointSize: size [

	^ self fontconfigPharoFamilyName: 'Source Code Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansPointSize [

	^ self
		  fontconfigPharoFamilyName: 'Source Sans Pro'
		  pointSize: StandardFonts defaultFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansPointSize: size [

	^ self fontconfigPharoFamilyName: 'Source Sans Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansSerifPointSize: size [

	^ self fontconfigPharoFamilyName: 'QTPalatine' pointSize: size
]
