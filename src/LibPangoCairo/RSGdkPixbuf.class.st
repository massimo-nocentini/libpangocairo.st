"
# Intro

I am a shape that holds a reference to a [GdkPixbuf](https://docs.gtk.org/gdk-pixbuf/class.Pixbuf.html) C object.
"
Class {
	#name : 'RSGdkPixbuf',
	#superclass : 'RSBoundingShape',
	#traits : 'TExternalAddressHolder',
	#classTraits : 'TExternalAddressHolder classTrait',
	#category : 'LibPangoCairo-Roassal',
	#package : 'LibPangoCairo',
	#tag : 'Roassal'
}

{ #category : 'finalization' }
RSGdkPixbuf class >> deallocateHandle: anExternalAddress [

	<primitive: 'primitive_g_object_unref' module: 'CairoGraphicsPlugin'>
	
]

{ #category : 'visitor' }
RSGdkPixbuf >> accept: visitor [

	visitor visitGdkPixbuf: self
]

{ #category : 'accessing' }
RSGdkPixbuf >> baseRectangle [

	| oPoint |
	oPoint := 0 @ 0.

	baseRectangle := self getHandle
		                 ifNil: [ oPoint corner: oPoint ]
		                 ifNotNil: [
			                 oPoint := self gdkPixbufGetWidthHeight:
				                           self getHandle.
			                 Rectangle extentCenteredAtCartesianOrigin: oPoint ].

	^ super baseRectangle
]

{ #category : 'primitives of CairoGraphicsPlugin' }
RSGdkPixbuf >> gdkPixbufGetWidthHeight: pixbufHandle [

	<primitive: 'primitive_gdk_pixbuf_get_width_height' module:
	'CairoGraphicsPlugin'>
	self primitiveFailed.
	^ 0 @ 0
]

{ #category : 'primitives of CairoGraphicsPlugin' }
RSGdkPixbuf >> gdkPixbufNewFromFile: fileName [
	"Bind the [`gdk_pixbuf_new_from_file`](https://docs.gtk.org/gdk-pixbuf/ctor.Pixbuf.new_from_file.html) C function."

	<primitive: 'primitive_gdk_pixbuf_new_from_file' module:
	'CairoGraphicsPlugin'>
	self primitiveFailed.
	^ ExternalAddress null
]

{ #category : 'initialization' }
RSGdkPixbuf >> initialize [

	super initialize.

	self addToTheResourceManager
]

{ #category : 'loading' }
RSGdkPixbuf >> loadFileReference: aFileReference [

	handle := self gdkPixbufNewFromFile: aFileReference fullName
]
