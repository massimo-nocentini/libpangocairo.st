Class {
	#name : 'PangoMicFigure',
	#superclass : 'Object',
	#instVars : [
		'micHttpResource'
	],
	#category : 'LibPangoCairo',
	#package : 'LibPangoCairo'
}

{ #category : 'converting' }
PangoMicFigure >> asRSPangoShapeUsingFont: aFont [

	| tmp |
	tmp := FileReference
		       newTempFilePrefix: 'pharo-mic-'
		       suffix: '-figure'.

	tmp binaryWriteStreamDo: [ :stream |
		stream nextPutAll: self micHttpResource binaryReadStream upToEnd ].

	^ tmp asGdkPixbufShape
]

{ #category : 'accessing' }
PangoMicFigure >> micHttpResource [

	^ micHttpResource
]

{ #category : 'accessing' }
PangoMicFigure >> micHttpResource: anObject [

	micHttpResource := anObject
]
