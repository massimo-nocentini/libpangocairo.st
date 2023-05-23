Class {
	#name : #PangoAttrList,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #accessing }
PangoAttrList class >> attr_list_from_string: text [

	^ self
		  ffiCall: #( PangoAttrList * pango_attr_list_from_string
			     #( const char * text ) )
		  module: PangoLibrary
]

{ #category : #accessing }
PangoAttrList >> ref [

	^ self ffiCall:
		  #( PangoAttrList * pango_attr_list_ref #( PangoAttrList
		        * self ) )
]

{ #category : #accessing }
PangoAttrList >> unref [

	^ self ffiCall:
		  #( void pango_attr_list_unref #( PangoAttrList * self ) )
]
