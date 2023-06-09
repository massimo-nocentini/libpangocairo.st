Class {
	#name : #TSCLanguage,
	#superclass : #TSLanguage,
	#instVars : [
		'braces'
	],
	#category : #Pango
}

{ #category : #initialization }
TSCLanguage >> initialize [

	super initialize.

	braces := 0.

	highlights
		at: 'comment' put: {
				('foreground #'
				 , (SHStyleElement withTokens: #( comment )) color asHexString).
				'style italic' };
		at: 'keyword' put: { 'weight bold' };
		at: 'operator' put: { 'weight bold' };
		at: 'label' put: { 'underline single' };
		at: 'function' put: {
				'style normal'.
				('foreground #'
				 , (SHStyleElement withTokens: #( selector )) color asHexString) };
		at: 'number' put: {
				('foreground #'
				 , (SHStyleElement withTokens: #( number )) color asHexString).
				'family Neo Euler' };
		at: 'type' put: {
				('foreground #'
				 , (SHStyleElement withTokens: #( pragma )) color asHexString).
				'weight bold' };
		at: 'variable' put: { ('foreground #'
			 , (SHStyleElement withTokens: #( instVar )) color asHexString) };
		at: 'property' put: { ('foreground #'
			 , (SHStyleElement withTokens: #( instVar )) color asHexString) };
		at: 'string' put: { ('foreground #'
			 , (SHStyleElement withTokens: #( string )) color asHexString) };
		at: 'constant' put: { ('foreground #'
			 , (SHStyleElement withTokens: { 'true' }) color asHexString) }
]

{ #category : #'as yet unclassified' }
TSCLanguage >> orderedPatterns [

	^ { 'number'. 'string'. 'function'. 'variable'. 'constant'. 'property'.
	  'operator'. 'keyword'. 'comment'. 'type' }
]
