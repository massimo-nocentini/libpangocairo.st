Class {
	#name : #TSJsonLanguage,
	#superclass : #TSLanguage,
	#instVars : [
		'braces'
	],
	#category : #Pango
}

{ #category : #accessing }
TSJsonLanguage >> at: pattern [
	"^ pattern = 'opening.brace'
		  ifTrue: [
			  self halt.
			  braces := braces + 1.
			  highlights at: 'brace' put: { ('foreground #'
				   ,
					   (SHStyleElement withTokens:
						    { ('parenthesis' , braces asString) }) color asHexString) }.
			  super at: 'brace' ]
		  ifFalse: [
			  pattern = 'closing.brace'
				  ifTrue: [
					  | v |
					  self halt.
					  v := super at: 'brace'.

					  braces := braces - 1.
					  highlights at: 'brace' put: { ('foreground #'
						   ,
							   (SHStyleElement withTokens:
								    { ('parenthesis' , braces asString) }) color asHexString) }.

					  v ]
				  ifFalse: [ super at: pattern ] ]"

	^ super at: pattern
]

{ #category : #initialization }
TSJsonLanguage >> initialize [

	super initialize.

	braces := 0.

	highlights
		at: 'string.special.key' put: {
				('foreground #'
				 , (SHStyleElement withTokens: #( comment )) color asHexString).
				'style italic'.
				'family Source Sans Pro' };
		at: 'opening.brace' put: { 'weight bold' };
		at: 'closing.brace' put: { 'weight bold' };
		at: 'number' put: {
				('foreground #'
				 , (SHStyleElement withTokens: #( number )) color asHexString).
				'family Neo Euler' };
		at: 'string' put: { ('foreground #'
			 , (SHStyleElement withTokens: #( string )) color asHexString) };
		at: 'constant.builtin' put: { ('foreground #'
			 , (SHStyleElement withTokens: { 'true' }) color asHexString) }
]

{ #category : #'as yet unclassified' }
TSJsonLanguage >> orderedPatterns [

	^ { 'number'. 'string.special.key'. 'constant.builtin'.
	  'string'. 'opening.brace'. 'closing.brace' }
]
