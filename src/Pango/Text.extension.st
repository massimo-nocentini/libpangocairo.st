Extension { #name : #Text }

{ #category : #'*Pango' }
Text >> asRSPangoText [

	^ RSPangoText new
		  text:
			  '<span foreground="gray" font_size="10pt"><tt>' , self asString
			  , '</tt></span>';
		  yourself
]
