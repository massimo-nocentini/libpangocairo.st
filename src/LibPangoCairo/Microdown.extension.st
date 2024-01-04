Extension { #name : 'Microdown' }

{ #category : '*LibPangoCairo' }
Microdown class >> asPangoMarkupString: aString [

	| mic |
	mic := self parse: aString.

	^ PangoMarkupMicrodownVisitor new
		  visit: mic;
		  pangoMarkup
]
