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

	| pangoMicVisitor mic |
	pangoMicVisitor := PangoMarkupMicrodownVisitor new.

	mic := Microdown parse: self targetClass comment.

	pangoMicVisitor visit: mic.

	^ RSCanvas new
		  @ RSCanvasController;
		  add:
			  (pangoMicVisitor asRSPangoShapeUsingFont: LogicalFont pangoSerif);
		  yourself
]

{ #category : 'initialization' }
RSUMLClassMicrodownCommentCalypso >> defaultTitle [

	^ 'RSComment'
]
