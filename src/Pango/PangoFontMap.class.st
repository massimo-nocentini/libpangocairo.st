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
