Class {
	#name : #RSPangoText,
	#superclass : #RSPangoWithAttrList,
	#instVars : [
		'textRuns'
	],
	#classVars : [
		'Conversions'
	],
	#category : #Pango
}

{ #category : #accessing }
RSPangoText >> attributesChunks [

	| collection |
	collection := OrderedCollection new.

	textRuns withStartStopAndValueDo: [ :start :stop :aCollection |
		aCollection do: [ :each |
			| chunks |
			chunks := each asPangoAttributeChunks: self font.

			chunks do: [ :chunk |
				| attrString |
				attrString := '{1} {2} {3}' format: {
						              (start - 1).
						              stop.
						              chunk }.

				collection add: attrString ] ] ].

	^ collection
]

{ #category : #accessing }
RSPangoText >> textRuns: anObject [

	textRuns := anObject
]
