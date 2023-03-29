Extension { #name : #Text }

{ #category : #'*Pango' }
Text >> asRSPangoText [

	| attributes |
	attributes := OrderedCollection new.
	self runs withStartStopAndValueDo: [ :start :stop :aCollection |
		aCollection do: [ :each |
			each asPangoAttributeString ifNotEmpty: [ :chunk |
				| attrString |
				attrString := '{1} {2} {3}' format: {
						              (start - 1).
						              (stop - 1).
						              chunk }.

				attributes add: attrString ] ] ].

	^ RSPangoText new
		  text:
			  '<span foreground="gray" font_size="10pt"><tt>' , self asString
			  , '</tt></span>';
		  attributesString: attributes;
		  yourself
]
