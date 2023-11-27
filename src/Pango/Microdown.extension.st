Extension { #name : #Microdown }

{ #category : #'*Pango' }
Microdown class >> asPangoMarkupString: aString [

	| mic |
	mic := self parse: aString.

	^ PangoMarkupMicrodownVisitor new
		  visit: mic;
		  pangoMarkup
]
