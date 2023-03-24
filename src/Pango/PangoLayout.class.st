Class {
	#name : #PangoLayout,
	#superclass : #FFIOpaqueObject,
	#traits : 'TPangoLibrary',
	#classTraits : 'TPangoLibrary classTrait',
	#category : #Pango
}

{ #category : #finalization }
PangoLayout class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	^ self g_object_unref: handle
]

{ #category : #private }
PangoLayout class >> g_object_unref: handle [
	^ self ffiCall: #( void g_object_unref (void *handle)) module: PangoLibrary
]

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
PangoLayout >> fontDescription: desc [
	self ffiCall: #(void pango_layout_set_font_description (self, const PangoFontDescription *desc))
]

{ #category : #accessing }
PangoLayout >> getExtentsInkRectangle: inkRectangle logicalRectangle: logicalRectangle [
	"https://docs.gtk.org/Pango/method.Layout.get_attributes.html"

	^ self ffiCall:
		  #( void pango_layout_get_extents #( self , PangoRectangle
		        * inkRectangle , PangoRectangle * logicalRectangle ) )
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

{ #category : #initialization }
PangoLayout >> initialize [
	self autoRelease
]

{ #category : #accessing }
PangoLayout >> inkOrLogicalRectangle: isLogical [

	| ll |
	ll := LibLua uniqueInstance.

	^ ll withOpenedLibsStateDo: [ :L |
		  | x y w h b |
		  ll
			  luaL_requiref: L name: 'cairo';
			  on: L push: #cairo;
			  lua_getfield: L at: -1 name: 'pango_layout_get_extents';
			  on: L push: self getHandle;
			  on: L push: isLogical.

		  ll assert: [ ll lua_pcall: L nargs: 2 nresults: 5 ].

		  b := ll on: L at: -5.
		  x := ll on: L at: -4.
		  y := ll on: L at: -3.
		  w := ll on: L at: -2.
		  h := ll on: L at: -1.

		  Rectangle origin: x @ y extent: w @ h ]
]

{ #category : #accessing }
PangoLayout >> inkRectangle [

	^ self inkOrLogicalRectangle: false
]

{ #category : #accessing }
PangoLayout >> logicalRectangle [

	^ self inkOrLogicalRectangle: true
]

{ #category : #accessing }
PangoLayout >> markup: markup [
	^ self ffiCall: #(void pango_layout_set_markup (self, const char *markup, -1))
]

{ #category : #private }
PangoLayout >> primGetSizeWidth: width height: height [
	self ffiCall: #(void pango_layout_get_size (self, int *width, int *height))

	
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
	self ffiCall: #(void pango_layout_set_text (self, const char *text, -1))
]

{ #category : #accessing }
PangoLayout >> width: width [
	self ffiCall: #(void pango_layout_set_width (self, int width))
]
