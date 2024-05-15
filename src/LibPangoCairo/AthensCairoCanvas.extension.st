Extension { #name : 'AthensCairoCanvas' }

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> layoutPath: layout [

	self
		ffiCall: #( void pango_cairo_layout_path #( self , void * layout ) )
		module: PangoCairoLibrary
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> newPangoLayout [

	self
		ffiCall: #( void * pango_cairo_create_layout
		   #( self ) )
		module: PangoCairoLibrary
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
