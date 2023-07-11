Class {
	#name : #PopplerLibrary,
	#superclass : #FFILibrary,
	#category : #Pango
}

{ #category : #'accessing platform' }
PopplerLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libpoppler-glib.so'
]
