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
PangoContext class >> font_map_create_context: fontmap [

	^ self
		  ffiCall: #( PangoContext * pango_font_map_create_context
			     #( PangoFontMap * fontmap ) )
		  module: PangoCairoLibrary
]

{ #category : #private }
PangoContext class >> g_object_unref: handle [
	^ self ffiCall: #( void g_object_unref (void *handle)) module: PangoLibrary
]

{ #category : #'instance creation' }
PangoContext class >> new: fontmap [

	^ (self font_map_create_context: fontmap) initialize
]

{ #category : #initialization }
PangoContext >> initialize [
	self autoRelease
]

{ #category : #'instance creation' }
PangoContext >> newLayout [

	^ PangoLayout newContext: self
]
