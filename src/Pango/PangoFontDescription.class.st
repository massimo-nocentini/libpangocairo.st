Class {
	#name : #PangoFontDescription,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #finalization }
PangoFontDescription class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	^ self pango_font_description_free: handle
]

{ #category : #'instance creation' }
PangoFontDescription class >> newFromString: aString [
	^ (self pango_font_description_from_string: aString) initialize
]

{ #category : #private }
PangoFontDescription class >> pango_font_description_free: desc [
	self ffiCall: #(void pango_font_description_free (void *desc))
]

{ #category : #private }
PangoFontDescription class >> pango_font_description_from_string: str [
	^ self ffiCall: #(PangoFontDescription *pango_font_description_from_string (const char *str))
]

{ #category : #initialization }
PangoFontDescription >> initialize [
	self autoRelease
]
