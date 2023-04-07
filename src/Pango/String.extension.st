Extension { #name : #String }

{ #category : #'*Pango' }
String >> fixEmptyLinesForPango [

	^ Character cr join:
		  (self lines collect: [ :l | l ifEmpty: [ Character space ] ])
]

{ #category : #'*Pango' }
String >> replaceAllTabsWithSpacesForPango [

	^ self
		  copyReplaceAll: self class tab
		  with: (self class space repeat: 3)
]
