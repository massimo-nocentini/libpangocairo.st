Extension { #name : 'ZnUrl' }

{ #category : '*LibPangoCairo' }
ZnUrl >> asRSPangoShapeUsingFont: aFont [

	| url |
	url := self asString.

	^ RSPangoText new
		  model: self;
		  font: aFont;
		  text: url;
		  when: RSMouseLeftClick
		  do: [ :ev | WebBrowser openOn: url ]
		  for: self;
		  yourself
]
