Class {
	#name : #PangoCairoLibrary,
	#superclass : #FFILibrary,
	#category : #Pango
}

{ #category : #'accessing platform' }
PangoCairoLibrary >> macModuleName [
	^ '/usr/local/lib/libpangocairo-1.0.0.dylib'

]

{ #category : #'accessing platform' }
PangoCairoLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libpangocairo-1.0.so'
]
