Extension { #name : #AthensCairoCanvas }

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
		ffiCall: #(void pango_cairo_show_layout (self, PangoLayout *layout))
		module: PangoCairoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> unrefPangoLayout: handler [

	self
		ffiCall: #( void g_object_unref #( void * handler ) )
		module: PangoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> updateLayout: layout [
	self 
		ffiCall: #(void pango_cairo_update_layout (self, PangoLayout *layout))
		module: PangoCairoLibrary
]

{ #category : #'*Pango' }
AthensCairoCanvas >> withPangoLayoutHandler: block [

	| layoutHandler |
	layoutHandler := self newPangoLayout.

	[ block value: layoutHandler ] ensure: [
		self unrefPangoLayout: layoutHandler ]
]
