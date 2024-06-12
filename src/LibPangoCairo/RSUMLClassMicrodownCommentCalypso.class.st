"
# Why

I am a variant that uses a Microdown visitor to produce a _Roassal rendering_ of the given class comment.
"
Class {
	#name : 'RSUMLClassMicrodownCommentCalypso',
	#superclass : 'RSUMLClassCalypso',
	#category : 'LibPangoCairo-Roassal',
	#package : 'LibPangoCairo',
	#tag : 'Roassal'
}

{ #category : 'testing' }
RSUMLClassMicrodownCommentCalypso class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [
		  aBrowserContext lastSelectedClass comment isNotEmpty ]
]

{ #category : 'building' }
RSUMLClassMicrodownCommentCalypso >> buildUmlCanvas [

	| shape mic |
	mic := Microdown parse: self targetClass comment.

	shape := PangoMarkupMicrodownVisitor new
		         visit: mic;
		         asRSPangoShapeUsingFont: LogicalFont pangoSerif.

	^ RSCanvas new
		  useRTree;
		  @ RSCanvasController;
		  add: shape;
		  yourself
]

{ #category : 'initialization' }
RSUMLClassMicrodownCommentCalypso >> defaultTitle [

	^ 'Microdown'
]
