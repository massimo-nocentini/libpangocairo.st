Extension { #name : 'AthensCairoCanvas' }

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> gdkCairoSetSourcePixbuf: pixbufHandle x: x y: y [

	<primitive: 'primitive_gdk_cairo_set_source_pixbuf' module:
	'CairoGraphicsPlugin'>
	self primitiveFailed
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> showLayout: layout [

	self
		ffiCall: #( void pango_cairo_show_layout #( self , void * layout ) )
		module: PangoCairoLibrary
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> updateContext: context [

	self
		ffiCall:
		#( void pango_cairo_update_context #( self , void * context ) )
		module: PangoCairoLibrary
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> updateLayout: layout [

	self
		ffiCall:
		#( void pango_cairo_update_layout #( self , void * layout ) )
		module: PangoCairoLibrary
]
