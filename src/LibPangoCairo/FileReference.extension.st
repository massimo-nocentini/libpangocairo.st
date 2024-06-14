Extension { #name : 'FileReference' }

{ #category : '*LibPangoCairo' }
FileReference >> asGdkPixbufShape [

	^ RSGdkPixbuf new
		  loadFileReference: self;
		  asCompositeShape
]
