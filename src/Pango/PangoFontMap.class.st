Class {
	#name : #PangoFontMap,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #private }
PangoFontMap class >> default [

	^ self font_map_get_default
]

{ #category : #finalization }
PangoFontMap class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	^ self g_object_unref: handle
]

{ #category : #private }
PangoFontMap class >> font_map_get_default [

	^ self
		  ffiCall: #( PangoFontMap * pango_cairo_font_map_get_default
			     #(  ) )
		  module: PangoCairoLibrary
]

{ #category : #private }
PangoFontMap class >> font_map_new [

	^ self
		  ffiCall: #( PangoFontMap * pango_cairo_font_map_new
		     #( void ) )
		  module: PangoCairoLibrary
]

{ #category : #private }
PangoFontMap class >> g_object_unref: handle [
	^ self ffiCall: #( void g_object_unref (void *handle)) module: PangoLibrary
]

{ #category : #private }
PangoFontMap class >> new [

	^ self font_map_new initialize
]

{ #category : #private }
PangoFontMap >> createContext [

	^ self
		  ffiCall: #( PangoContext * pango_font_map_create_context
			     #( PangoFontMap * self ) )
		  module: PangoLibrary
]

{ #category : #initialization }
PangoFontMap >> initialize [
	self autoRelease
]
