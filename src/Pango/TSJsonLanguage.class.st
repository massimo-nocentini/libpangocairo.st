Class {
	#name : #TSJsonLanguage,
	#superclass : #TSLanguage,
	#category : #Pango
}

{ #category : #initialization }
TSJsonLanguage >> initialize [

	super initialize.

	highlights
		at: 'string.special.key' put: {
				('foreground #'
				 , (SHStyleElement withTokens: #( selector )) color asHexString).
				'style italic'.
				'family Source Sans Pro' };
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
	  'string' }
]
