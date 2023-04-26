Class {
	#name : #PangoAttrList,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #accessing }
PangoAttrList class >> attr_list_from_string: text [

	^ self ffiCall:
		  #( PangoAttrList * pango_attr_list_from_string #( const char * text ) )
]

{ #category : #finalization }
PangoAttrList class >> finalizeResourceData: handle [

	handle isNull ifTrue: [ ^ self ].
	^ self pango_attr_list_unref: handle
]

{ #category : #private }
PangoAttrList class >> pango_attr_list_unref: handle [

	^ self ffiCall:
		  #( void pango_attr_list_unref #( PangoAttrList * handle ) )
]

{ #category : #initialization }
PangoAttrList >> initialize [

	self autoRelease
]

{ #category : #accessing }
PangoAttrList >> ref [

	^ self ffiCall:
		  #( PangoAttrList * pango_attr_list_ref #( PangoAttrList
		        * self ) )
]
