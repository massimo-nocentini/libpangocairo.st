Extension { #name : #String }

{ #category : #'*Pango' }
String >> asRSPangoMarkupUsingFont: font [

	| markup |
	markup := self class streamContents: [ :stream |
		          stream
			          << '<markup>';
			          << self;
			          << '</markup>' ].

	^ RSPangoMarkup new
		  font: font;
		  markup: markup;
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
