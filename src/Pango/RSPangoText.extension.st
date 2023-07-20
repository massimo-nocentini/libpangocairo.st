Extension { #name : #RSPangoText }

{ #category : #'*Pango' }
RSPangoText >> g_object_unref: handler [

	self
		ffiCall: #( void g_object_unref #( void #* handler ) )
		module: PangoLibrary
]
