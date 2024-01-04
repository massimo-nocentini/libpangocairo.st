Trait {
	#name : 'TPangoLibrary',
	#category : 'LibPangoCairo',
	#package : 'LibPangoCairo'
}

{ #category : 'library path' }
TPangoLibrary classSide >> ffiLibraryName [
	^ PangoLibrary
]

{ #category : 'library path' }
TPangoLibrary >> ffiLibraryName [
	^ self class ffiLibraryName
]
