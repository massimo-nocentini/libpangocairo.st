Extension { #name : #LogicalFont }

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMath [

	^ self
		  familyName: 'Neo Euler'
		  pointSize: StandardFonts codeFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMathPointSize: size [

	^ self familyName: 'Neo Euler' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMonospace [

	^ self fontconfigPharoMonospacePointSize:
		  StandardFonts codeFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoMonospacePointSize: size [

	^ self familyName: 'Source Code Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSans [

	^ self fontconfigPharoSansPointSize:
		  StandardFonts defaultFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansPointSize: size [

	^ self familyName: 'Source Sans Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansSerif [

	^ self fontconfigPharoSansSerifPointSize:
		  StandardFonts defaultFont pointSize
]

{ #category : #'*Pango' }
LogicalFont class >> fontconfigPharoSansSerifPointSize: size [

	^ self familyName: 'Source Serif Pro' pointSize: size
]

{ #category : #'*Pango' }
LogicalFont >> pangoMarkupSpanTagContent [

	^ 'font_family="{1}" font_size="{2}pt"' format: {
			  self familyName.
			  self pointSize }
]
