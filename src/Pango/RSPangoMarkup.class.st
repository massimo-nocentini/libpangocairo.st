Class {
	#name : #RSPangoMarkup,
	#superclass : #RSPangoText,
	#category : #Pango
}

{ #category : #'as yet unclassified' }
RSPangoMarkup >> freeResource: resource ofPangoLayout: fontLayout [
]

{ #category : #'as yet unclassified' }
RSPangoMarkup >> initPangoLayout: aPangoLayout [

	aPangoLayout markup: (self markup ifNil: [ '<span></span>' ])
]

{ #category : #accessing }
RSPangoMarkup >> markup [

	^ self text
]

{ #category : #accessing }
RSPangoMarkup >> markup: anObject [

	| fixed |
	fixed := Character cr join: (anObject lines collect: [ :aString |
			          aString ifEmpty: [ Character nbsp ] ]).

	^ self text: fixed
]
