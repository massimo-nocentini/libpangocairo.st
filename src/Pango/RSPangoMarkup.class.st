Class {
	#name : #RSPangoMarkup,
	#superclass : #RSPangoText,
	#category : #Pango
}

{ #category : #handle }
RSPangoMarkup >> initPangoLayout: aPangoLayout [

	aPangoLayout markup: (self markup ifNil: [ '<span></span>' ]).

	^ ExternalAddress null
]

{ #category : #accessing }
RSPangoMarkup >> markup [

	^ self text
]

{ #category : #accessing }
RSPangoMarkup >> markup: aString [

	^ self text: aString fixEmptyLinesForPango
]
