Class {
	#name : #PangoLayout,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #'instance creation' }
PangoLayout class >> newCanvas: aCanvas [

	^ self pango_cairo_create_layout: aCanvas
]

{ #category : #'instance creation' }
PangoLayout class >> newContext: aContext [

	^ self pango_layout_new: aContext
]

{ #category : #private }
PangoLayout class >> pango_cairo_create_layout: cr [
	^ self 
		ffiCall: #(PangoLayout *pango_cairo_create_layout (AthensCairoCanvas cr))
		module: PangoCairoLibrary
]

{ #category : #private }
PangoLayout class >> pango_layout_new: context [
	^ self ffiCall: #(PangoLayout *pango_layout_new (PangoContext *context))
]

{ #category : #accessing }
PangoLayout >> font_description_from_string: str [

	self ffiCall:
		#( PangoFontDescription * pango_font_description_from_string
		   #( const char * str ) )
]

{ #category : #accessing }
PangoLayout >> get_line_count [

	^ self ffiCall: #( int pango_layout_get_line_count
	     #( self ) )
]

{ #category : #accessing }
PangoLayout >> get_line_spacing [

	^ self ffiCall: #( float pango_layout_get_line_spacing
	     #( self ) )
]

{ #category : #accessing }
PangoLayout >> get_spacing [

	^ self ffiCall: #( int pango_layout_get_spacing
	     #( self ) )
]

{ #category : #accessing }
PangoLayout >> logicalRectangle [

	^ Rectangle origin: 0 @ 0 extent: self pixelSize
]

{ #category : #accessing }
PangoLayout >> markup: markup [
	^ self ffiCall: #(void pango_layout_set_markup (self, const char *markup, -1))
]

{ #category : #accessing }
PangoLayout >> pixelSize [

	| widthBuffer heightBuffer |
	widthBuffer := ByteArray new: FFIInt32 externalTypeSize.
	heightBuffer := ByteArray new: FFIInt32 externalTypeSize.
	self primGetPixelSizeWidth: widthBuffer height: heightBuffer.
	^ (widthBuffer signedLongAt: 1) @ (heightBuffer signedLongAt: 1)
]

{ #category : #private }
PangoLayout >> primGetPixelSizeWidth: width height: height [

	self ffiCall:
		#( void pango_layout_get_pixel_size #( self , int * width , int * height ) )
]

{ #category : #private }
PangoLayout >> primGetSizeWidth: width height: height [
	self ffiCall: #(void pango_layout_get_size (self, int *width, int *height))

	
]

{ #category : #accessing }
PangoLayout >> pushOnLua: state liblua: liblua [

	^ liblua on: state push: handle
]

{ #category : #accessing }
PangoLayout >> set_attributes: attrListExternalAddress [

	self ffiCall:
		#( void pango_layout_set_attributes #( self , void * attrListExternalAddress ) )
]

{ #category : #accessing }
PangoLayout >> set_font_description: desc [
	self ffiCall: #(void pango_layout_set_font_description (self, const PangoFontDescription *desc))
]

{ #category : #accessing }
PangoLayout >> set_line_spacing: spacing [

	^ self ffiCall:
		  #( void pango_layout_set_line_spacing
		     #( self , float spacing ) )
]

{ #category : #accessing }
PangoLayout >> set_single_paragraph_mode: b [

	^ self ffiCall: #( void pango_layout_set_single_paragraph_mode
		     #( self , bool b ) )
]

{ #category : #accessing }
PangoLayout >> set_spacing: spacing [

	^ self ffiCall:
		  #( void pango_layout_set_spacing #( self , int spacing ) )
]

{ #category : #accessing }
PangoLayout >> size [ 
	| widthBuffer heightBuffer |
	widthBuffer := ByteArray new: FFIInt32 externalTypeSize.
	heightBuffer := ByteArray new: FFIInt32 externalTypeSize.
	self primGetSizeWidth: widthBuffer height: heightBuffer.
	^ (widthBuffer signedLongAt: 1) @ (heightBuffer signedLongAt: 1)
]

{ #category : #accessing }
PangoLayout >> text: text [

	^ self ffiCall:
		  #( void pango_layout_set_text #( self , const char * text , -1 ) )
]

{ #category : #accessing }
PangoLayout >> unref [

	^ self
		  ffiCall: #( void g_object_unref #( void * self ) )
		  module: PangoLibrary
]

{ #category : #accessing }
PangoLayout >> width: width [
	self ffiCall: #(void pango_layout_set_width (self, int width))
]
