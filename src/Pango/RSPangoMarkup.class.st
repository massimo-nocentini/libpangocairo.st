Class {
	#name : #RSPangoMarkup,
	#superclass : #RSPangoText,
	#classVars : [
		'Conversions'
	],
	#category : #Pango
}

{ #category : #initialization }
RSPangoMarkup class >> initialize [

	Conversions := Dictionary new
		               at: '\infty' put: '&#8734;';
		               at: '\forall' put: '&#8704;';
		               at: '\thereexists' put: '&#8707;';
		               at: '\elementof' put: '&#8712;';
		               at: '\minussign' put: '&#8722;';
		               at: '\alpha' put: '&#0945;';
		               at: '\bullet' put: '&#8226;';
		               yourself
]

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

	| s |
	s := aString fixEmptyLinesForPango.

	Conversions keysAndValuesDo: [ :macro :replacement |
		s := s copyReplaceAll: macro with: replacement ].

	^ self text: s
]
