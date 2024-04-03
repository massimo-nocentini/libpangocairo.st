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
		  (aBrowserContext selectedMethods select: [ :method |
			   method hasPragmaNamed: #notebook ]) isNotEmpty ]
]

{ #category : 'building' }
RSUMLNotebookCalypso >> buildUmlCanvas [

	| method methods presenter notebook shape pseudoVariableName |
	methods := self context selectedMethods select: [ :each |
		           each hasPragmaNamed: #notebook ].

	method := methods ifEmpty: [ ^ RSCanvas new ] ifNotEmpty: #first.

	presenter := SpCodePresenter new
		             beForScripting;
		             yourself.

	pseudoVariableName := method sourceNode arguments
		                      ifEmpty: [ 'dummyNotebook' ]
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

	shape := notebook asShapeSlotsDfsTree: CTDfsWalker new.

	^ RSCanvas new
		  useRTree;
		  add: shape;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'initialization' }
RSUMLNotebookCalypso >> defaultTitle [

	^ 'Notebook'
]
