Class {
	#name : #PangoAttrList,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #finalization }
PangoAttrList class >> finalizeResourceData: handle [

	handle isNull ifTrue: [ ^ self ].
	^ self pango_attr_list_unref: handle
]

{ #category : #private }
PangoAttrList class >> pango_attr_list_unref: handle [
	^ self ffiCall: #( void pango_attr_list_unref (PangoAttrList *handle)) module: PangoLibrary
]

{ #category : #initialization }
PangoAttrList >> initialize [

	self autoRelease
]
