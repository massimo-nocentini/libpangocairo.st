Class {
	#name : #PangoLibrary,
	#superclass : #FFILibrary,
	#category : #Pango
}

{ #category : #'accessing platform' }
PangoLibrary >> macModuleName [
	^ '/opt/local/lib/libpango-1.0.0.dylib'
]
