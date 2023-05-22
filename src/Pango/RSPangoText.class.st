Class {
	#name : #RSPangoText,
	#superclass : #RSPangoWithAttrList,
	#instVars : [
		'textRuns',
		'tripleFormatString'
	],
	#classVars : [
		'Conversions'
	],
	#category : #Pango
}

{ #category : #accessing }
RSPangoText >> attributesChunks [

	| triples |
	triples := OrderedCollection new.

	textRuns withStartStopAndValueDo: [ :shiftedStart :stop :textAttributes |
		| start |
		start := shiftedStart - 1.

		textAttributes do: [ :each |
			| chunks |
			chunks := each asPangoAttributeChunks: self font.

			chunks do: [ :chunk |
				| triple |
				triple := self formatTripleFrom: start to: stop value: chunk.

				triples add: triple ] ] ].

	^ triples
]

{ #category : #accessing }
RSPangoText >> formatTripleFrom: start to: stop value: chunk [

	^ tripleFormatString format: {
			  start.
			  stop.
			  chunk }
]

{ #category : #accessing }
RSPangoText >> initialize [

	super initialize.

	tripleFormatString := '{1} {2} {3}'
]

{ #category : #accessing }
RSPangoText >> textRuns: anObject [

	textRuns := anObject
]
