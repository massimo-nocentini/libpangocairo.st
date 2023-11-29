Trait {
	#name : #TPangoLibrary,
	#category : 'Pango'
}

{ #category : #'library path' }
TPangoLibrary classSide >> ffiLibraryName [
	^ PangoLibrary
]

{ #category : #'library path' }
TPangoLibrary >> ffiLibraryName [
	^ self class ffiLibraryName
]
