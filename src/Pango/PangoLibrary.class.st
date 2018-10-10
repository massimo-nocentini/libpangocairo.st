Class {
	#name : #PangoLibrary,
	#superclass : #FFILibrary,
	#category : #Pango
}

{ #category : #'accessing platform' }
PangoLibrary >> macModuleName [
	^ '/usr/local/lib/libpango-1.0.0.dylib'
]
