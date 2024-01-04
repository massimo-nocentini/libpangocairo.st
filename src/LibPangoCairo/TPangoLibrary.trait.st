Trait {
	#name : 'TPangoLibrary',
	#category : 'LibPangoCairo-FFILibrary',
	#package : 'LibPangoCairo',
	#tag : 'FFILibrary'
}

{ #category : 'library path' }
TPangoLibrary classSide >> ffiLibraryName [
	^ PangoLibrary
]

{ #category : 'library path' }
TPangoLibrary >> ffiLibraryName [
	^ self class ffiLibraryName
]
