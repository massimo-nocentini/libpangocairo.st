Class {
	#name : 'PangoCairoLibrary',
	#superclass : 'FFILibrary',
	#category : 'LibPangoCairo-FFILibrary',
	#package : 'LibPangoCairo',
	#tag : 'FFILibrary'
}

{ #category : 'accessing platform' }
PangoCairoLibrary >> macLibraryName [

	^ FFIMacLibraryFinder findLibrary: 'libpangocairo-1.0.0.dylib'
]

{ #category : 'accessing platform' }
PangoCairoLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libpangocairo-1.0.so'
]
