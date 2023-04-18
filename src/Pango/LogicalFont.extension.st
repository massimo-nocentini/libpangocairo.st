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
LogicalFont class >> fontconfigPharoSansPointSize: size [

	^ self fontconfigPharoFamilyName: 'Concrete Math' pointSize: size
]
