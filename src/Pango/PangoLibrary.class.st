Class {
	#name : #PangoLibrary,
	#superclass : #FFILibrary,
	#category : #Pango
}

{ #category : #'accessing platform' }
PangoLibrary >> macLibraryName [

	^ FFIMacLibraryFinder findLibrary: 'libpango-1.0.0.dylib'
]

{ #category : #'accessing platform' }
PangoLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libpango-1.0.so'
]
