Extension { #name : #Text }

{ #category : #'*Pango' }
Text >> asRSPangoText [

	| attributes |
	attributes := OrderedCollection new.

	attributes
		add: '0 -1 foreground #' , Color black asHexString;
		add: '0 -1 font-desc "monospace 10"'.

	self runs withStartStopAndValueDo: [ :start :stop :aCollection |
		aCollection do: [ :each |
			each asPangoAttributeChunks do: [ :chunk |
				| attrString |
				attrString := '{1} {2} {3}' format: {
						              (start - 1).
						              stop.
						              chunk }.

				attributes add: attrString ] ] ].

	^ RSPangoText new
		  attributesString: attributes;
		  text: self asString;
		  yourself
]
