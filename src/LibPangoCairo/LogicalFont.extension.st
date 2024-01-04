Extension { #name : 'LogicalFont' }

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoMath [

	^ self pangoMathPointSize: StandardFonts codeFont pointSize
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoMathPointSize: size [

	^ self familyName: 'Euler Math' pointSize: size
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoMonospace [

	^ self pangoMonospacePointSize:
		  StandardFonts codeFont pointSize
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoMonospacePointSize: size [

	^ self familyName: 'Source Code Pro' pointSize: size
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoSans [

	^ self pangoSansPointSize:
		  StandardFonts defaultFont pointSize
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoSansPointSize: size [

	^ self familyName: 'Source Sans Pro' pointSize: size
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoSerif [

	^ self pangoSerifPointSize:
		  StandardFonts defaultFont pointSize
]

{ #category : '*LibPangoCairo' }
LogicalFont class >> pangoSerifPointSize: size [

	^ self familyName: 'Source Serif Pro' pointSize: size
]
