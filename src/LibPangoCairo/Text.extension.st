Extension { #name : 'Text' }

{ #category : '*LibPangoCairo' }
Text >> asRSPangoShapeUsingFont: aFont [

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

	^ RSPangoText new
		  model: self;
		  font: aFont;
		  attributesChunks: attributes;
		  text: self asString;
		  yourself
]
