Class {
	#name : #TSLanguage,
	#superclass : #Object,
	#instVars : [
		'highlights',
		'matches'
	],
	#category : #Pango
}

{ #category : #'private - accessing' }
TSLanguage class >> json [

	^ TSJsonLanguage new
]

{ #category : #accessing }
TSLanguage >> at: pattern [

	^ highlights at: pattern ifAbsent: [ #(  ) ]
]

{ #category : #initialization }
TSLanguage >> initialize [

	super initialize.

	highlights := Dictionary new
]

{ #category : #accessing }
TSLanguage >> matches: anObject [

	matches := anObject
]

{ #category : #'as yet unclassified' }
TSLanguage >> orderedPatterns [

	^ matches keys
]

{ #category : #'as yet unclassified' }
TSLanguage >> populate: chunks offset: i text: clean_text [

	| sorted |
	sorted := SortedCollection sortUsing: [ :a :b |
		          a first = b first
			          ifTrue: [ a fourth > b fourth ]
			          ifFalse: [ a first < b first ] ].

	self orderedPatterns withIndexDo: [ :pattern :priority |
		matches at: pattern ifPresent: [ :captures |
			| specs |
			specs := self at: pattern.
			captures do: [ :capture |
				| abs from to |
				abs := capture at: 'absolute'.

				from := (abs at: 'from') + i.
				to := (abs at: 'to') + i + 1.

				capture at: 'content' put: (clean_text copyFrom: from to: to).

				specs do: [ :spec |
					sorted add: {
							from.
							to.
							spec.
							priority } ] ] ] ].

	sorted do: [ :triple | chunks add: ('{1} {2} {3}' format: triple) ]
]