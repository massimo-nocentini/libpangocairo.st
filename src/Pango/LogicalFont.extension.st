Extension { #name : #LogicalFont }

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoFamilyName: familyName pointSize: size [

	^ self familyName: 'pharo' , familyName pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMonospacePointSize: size [

	^ self fontconfigPharoFamilyName: 'monospace' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansPointSize: size [

	^ self fontconfigPharoFamilyName: 'sans-serif' pointSize: size
]
