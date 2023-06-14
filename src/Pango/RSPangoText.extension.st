Extension { #name : #RSPangoText }

{ #category : #'*Pango' }
RSPangoText >> gObjectUnref: handler [

	self
		ffiCall: #( void g_object_unref #( void * handler ) )
		module: PangoLibrary
]
