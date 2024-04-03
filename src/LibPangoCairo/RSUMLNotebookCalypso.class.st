"
# Why

I am a variant that uses a Microdown visitor to produce a _Roassal rendering_ of the given class comment.
"
Class {
	#name : 'RSUMLNotebookCalypso',
	#superclass : 'RSUMLClassCalypso',
	#category : 'LibPangoCairo-Roassal',
	#package : 'LibPangoCairo',
	#tag : 'Roassal'
}

{ #category : 'testing' }
RSUMLNotebookCalypso class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [
		  aBrowserContext selectedMethods size == 1 and: [
			  | method |
			  method := aBrowserContext selectedMethods first.

			  method protocol name beginsWith: 'notebook' ] ]
]

{ #category : 'building' }
RSUMLNotebookCalypso >> buildUmlCanvas [

	| walker method methods presenter notebook shape |
	walker := CTDfsWalker new.

	methods := self context selectedMethods.

	method := methods size = 1
		          ifTrue: [ methods first ]
		          ifFalse: [ ^ RSCanvas new ].

	presenter := SpCodePresenter new
		             beForScripting;
		             yourself.

	notebook := CTNotebookKeyedValuedOrderedCollection new.

	presenter interactionModel addBinding: (WorkspaceVariable
			 key: method sourceNode arguments first name
			 value: notebook).


	presenter text: method sourceNode  body formattedCode.

	notebook codePresenter: presenter.

	notebook value.

	shape := notebook asShapeSlotsDfsTree: walker.

	^ RSCanvas new
		  useRTree;
		  add: shape;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'initialization' }
RSUMLNotebookCalypso >> defaultTitle [

	^ 'Selected Notebook'
]
