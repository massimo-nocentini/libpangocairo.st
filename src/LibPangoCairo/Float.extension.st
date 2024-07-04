Extension { #name : 'Float' }

{ #category : '*LibPangoCairo' }
Float >> fullPangoPrintString [

	^ self = Infinity
		  ifTrue: [ '\infty' ]
		  ifFalse: [
			  self = NegativeInfinity
				  ifTrue: [ '\minussign\infty' ]
				  ifFalse: [ super fullPangoPrintString ] ]
]
