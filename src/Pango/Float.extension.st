Extension { #name : 'Float' }

{ #category : '*Pango' }
Float >> fullPangoPrintString [

	^ self = Infinity
		  ifTrue: [ '\infty' ]
		  ifFalse: [
			  self = NegativeInfinity
				  ifTrue: [ '\minussign\infty' ]
				  ifFalse: [ self fullPrintString ] ]
]
