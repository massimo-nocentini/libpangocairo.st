Extension { #name : 'ZnUrl' }

{ #category : '*LibPangoCairo' }
ZnUrl >> asRSPangoShapeUsingFont: aFont [

	| url |
	url := self asString.

	^ RSPangoText new
		  text: url;
		  when: RSMouseLeftClick
		  do: [ :ev | WebBrowser openOn: url ]
		  for: self;
		  asCompositeShape
]
