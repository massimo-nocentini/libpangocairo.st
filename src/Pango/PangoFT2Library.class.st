Class {
	#name : #PangoFT2Library,
	#superclass : #FFILibrary,
	#category : #Pango
}

{ #category : #'accessing platform' }
PangoFT2Library >> macModuleName [

	^ FFIMacLibraryFinder findLibrary: 'libpangoft2-1.0.0.dylib'
]

{ #category : #'accessing platform' }
PangoFT2Library >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libpangoft2-1.0.so'
]
