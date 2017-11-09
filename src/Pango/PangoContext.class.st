Class {
	#name : #PangoContext,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #finalization }
PangoContext class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	^ self g_object_unref: handle
]

{ #category : #private }
PangoContext class >> g_object_unref: handle [
	^ self ffiCall: #( void g_object_unref (void *handle)) module: PangoLibrary
]

{ #category : #initialization }
PangoContext >> initialize [
	self autoRelease
]
