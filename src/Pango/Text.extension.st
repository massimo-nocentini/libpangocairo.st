Extension { #name : #Text }

{ #category : #'*Pango' }
Text >> asRSPangoTextUsingFont: aFont [

	^ RSPangoText new
		  font: aFont;
		  textRuns: self runs;
		  text: self asString;
		  yourself
]
