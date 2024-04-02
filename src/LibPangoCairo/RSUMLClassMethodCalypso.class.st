"
# Why

I am a variant that uses a Microdown visitor to produce a _Roassal rendering_ of the given class comment.
"
Class {
	#name : 'RSUMLClassMethodCalypso',
	#superclass : 'RSUMLClassCalypso',
	#category : 'LibPangoCairo-Roassal',
	#package : 'LibPangoCairo',
	#tag : 'Roassal'
}

{ #category : 'testing' }
RSUMLClassMethodCalypso class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [
		  aBrowserContext selectedMethods isNotEmpty ]
]

{ #category : 'building' }
RSUMLClassMethodCalypso >> buildUmlCanvas [

	| walker shape methods |
	walker := CTDfsWalker new.

	methods := self context selectedMethods.

	shape := (methods size > 1
		          ifTrue: [ methods ]
		          ifFalse: [ methods last ]) asShapeSlotsDfsTree: walker.

	^ RSCanvas new
		  useRTree;
		  add: shape;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'initialization' }
RSUMLClassMethodCalypso >> defaultTitle [

	^ 'Selected Methods'
]
