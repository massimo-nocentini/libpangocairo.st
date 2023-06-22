Extension { #name : #String }

{ #category : #'*Pango' }
String >> asRSPangoMarkupUsingFont: font [

	^ RSPangoMarkup new
		  font: font;
		  markup: self;
		  yourself
]

{ #category : #'*Pango' }
String >> fixEmptyLinesForPango [

	^ self fixEmptyLinesForPangoUsingJoiner: Character cr
]

{ #category : #'*Pango' }
String >> fixEmptyLinesForPangoUsingJoiner: joiner [

	^ joiner join: ((Character cr split: self) collect: [ :l |
			   l ifEmpty: [ self class space ] ])
]

{ #category : #'*Pango' }
String >> replaceAllTabsWithSpacesForPango [

	^ self
		  copyReplaceAll: self class tab
		  with: (self class space repeat: 3)
]
