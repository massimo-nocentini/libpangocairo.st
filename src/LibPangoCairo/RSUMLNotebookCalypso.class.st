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

	| walker method methods presenter notebook shape pseudoVariableName |
	walker := CTDfsWalker new.

	methods := self context selectedMethods.

	method := methods size = 1
		          ifTrue: [ methods first ]
		          ifFalse: [ ^ RSCanvas new ].

	presenter := SpCodePresenter new
		             beForScripting;
		             yourself.

	pseudoVariableName := method sourceNode arguments
		                      ifEmpty: [ 'dummyNotebooko' ]
		                      ifNotEmpty: [ :args | args first name ].

	notebook := CTNotebookKeyedValuedOrderedCollection new
		            pseudoVariableName: pseudoVariableName;
		            yourself.

	presenter interactionModel addBinding:
		(WorkspaceVariable key: pseudoVariableName value: notebook).


	presenter text:
		(RBParser parseExpression: method sourceNode body formattedCode)
			formattedCode.

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
