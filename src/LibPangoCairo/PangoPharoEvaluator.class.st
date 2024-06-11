Class {
	#name : 'PangoPharoEvaluator',
	#superclass : 'Object',
	#instVars : [
		'evaluator',
		'source'
	],
	#category : 'LibPangoCairo',
	#package : 'LibPangoCairo'
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
						                asCompositeShape);
				               add:
				               (text asRSPangoShapeUsingFont:
					                LogicalFont pangoMonospace);
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
