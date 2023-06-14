Extension { #name : #RSPangoText }

{ #category : #'*Pango' }
RSPangoText >> unrefPangoLayout: handler [

	self
		ffiCall: #( void g_object_unref #( void * handler ) )
		module: PangoLibrary
]
