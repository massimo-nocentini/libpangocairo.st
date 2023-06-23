Extension { #name : #LogicalFont }

{ #category : #'*Pango' }
LogicalFont >> pangoMarkupSpanTagContent [

	^ 'font_family="{1}" font_size="{2}pt"' format: {
			  self familyName.
			  self pointSize }
]

{ #category : #'*Pango' }
LogicalFont class >> pangoMath [

	^ self pangoMathPointSize: StandardFonts codeFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> pangoMathPointSize: size [

	^ self familyName: 'Neo Euler' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> pangoMonospace [

	^ self pangoMonospacePointSize:
		  StandardFonts codeFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> pangoMonospacePointSize: size [

	^ self familyName: 'Source Code Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> pangoSans [

	^ self pangoSansPointSize:
		  StandardFonts defaultFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> pangoSansPointSize: size [

	^ self familyName: 'Source Sans Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> pangoSerif [

	^ self pangoSerifPointSize:
		  StandardFonts defaultFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> pangoSerifPointSize: size [

	^ self familyName: 'Source Serif Pro' pointSize: size
]
