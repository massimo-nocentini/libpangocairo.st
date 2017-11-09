Trait {
	#name : #TPangoFT2Library,
	#category : #Pango
}

{ #category : #'library path' }
TPangoFT2Library classSide >> ffiLibraryName [
	^ PangoFT2Library
]

{ #category : #'library path' }
TPangoFT2Library >> ffiLibraryName [
	^ self class ffiLibraryName
]
