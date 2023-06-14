Extension { #name : #AthensCairoCanvas }

{ #category : #'*Pango' }
AthensCairoCanvas >> getHandle [

	^ handle
]

{ #category : #'*Pango' }
AthensCairoCanvas >> layoutPath: layout [

	self
		ffiCall: #( void pango_cairo_layout_path #( self , void * layout ) )
		module: PangoCairoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> newPangoLayout [

	self
		ffiCall: #( void * pango_cairo_create_layout
		   #( self ) )
		module: PangoCairoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> showLayout: layout [

	self
		ffiCall: #( void pango_cairo_show_layout #( self , void * layout ) )
		module: PangoCairoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> updateContext: context [

	self
		ffiCall:
		#( void pango_cairo_update_context #( self , void * context ) )
		module: PangoCairoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> updateLayout: layout [

	self
		ffiCall:
		#( void pango_cairo_update_layout #( self , void * layout ) )
		module: PangoCairoLibrary
]
