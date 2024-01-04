Extension { #name : 'TextEmphasis' }

{ #category : '*LibPangoCairo' }
TextEmphasis >> asPangoAttributeChunks: aFont [

	^ self emphasisCode = self class bold emphasisCode
		  ifTrue: [ { 'weight bold' } ]
		  ifFalse: [
			  self emphasisCode = self class italic emphasisCode
				  ifTrue: [ { 'style italic' } ]
				  ifFalse: [
					  self emphasisCode = self class underlined emphasisCode
						  ifTrue: [ { 'underline single' } ]
						  ifFalse: [
							  self emphasisCode = self class struckOut emphasisCode
								  ifTrue: [ { 'strikethrough true' } ]
								  ifFalse: [ { 'style normal' } ] ] ] ]
]
