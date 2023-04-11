Extension { #name : #Text }

{ #category : #'*Pango' }
Text >> asRSPangoTextUsingFont: aFont [

	^ self asRSPangoTextUsingFont: aFont postAttributeChunks: {  }
]

{ #category : #'*Pango' }
Text >> asRSPangoTextUsingFont: aFont postAttributeChunks: postAttributes [

	| attributes |
	attributes := OrderedCollection new.

	self runs withStartStopAndValueDo: [ :start :stop :aCollection |
		aCollection do: [ :each |
			| chunks |
			chunks := each asPangoAttributeChunks: aFont.

			chunks do: [ :chunk |
				| attrString |
				attrString := '{1} {2} {3}' format: {
						              (start - 1).
						              stop.
						              chunk }.

				attributes add: attrString ] ] ].

	attributes addAll: postAttributes.

	^ RSPangoText new
		  font: aFont;
		  attributesChunks: attributes;
		  text: self asString;
		  yourself
]
