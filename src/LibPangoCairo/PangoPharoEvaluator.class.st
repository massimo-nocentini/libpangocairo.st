Class {
	#name : 'PangoPharoEvaluator',
	#superclass : 'Object',
	#instVars : [
		'evaluator',
		'source'
	],
	#category : 'LibPangoCairo-Microdown',
	#package : 'LibPangoCairo',
	#tag : 'Microdown'
}

{ #category : 'converting' }
PangoPharoEvaluator >> asRSPangoShapeUsingFont: aFont [

	| result src |
	src := self source.
	result := self evaluator
		          text: src;
		          evaluate: src onCompileError: [
			          | text g |
			          text := self evaluator textWithStyle.

			          g := RSGroup new
				               add: (RSPangoMarkup new
						                text:
							                '<span foreground="red">Syntactic error:</span>';
						                yourself);
				               add: (text asRSPangoShapeUsingFont: aFont);
				               yourself.

			          RSVerticalLineLayout new
				          alignLeft;
				          on: g.

			          ^ g asShape ]
		          onError: [ :e | e ].

	^ result asShapeSlotsDfsTree: CTDfsWalker new
]

{ #category : 'accessing' }
PangoPharoEvaluator >> evaluator [

	^ evaluator
]

{ #category : 'accessing' }
PangoPharoEvaluator >> evaluator: anObject [

	evaluator := anObject
]

{ #category : 'accessing' }
PangoPharoEvaluator >> source [

	^ source
]

{ #category : 'accessing' }
PangoPharoEvaluator >> source: anObject [

	source := anObject
]
