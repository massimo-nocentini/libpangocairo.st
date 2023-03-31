Extension { #name : #String }

{ #category : #'*Pango' }
String >> fixEmptyLinesForPango [

	^ Character cr join:
		  (self lines collect: [ :l | l ifEmpty: [ ' ' ] ])
]
