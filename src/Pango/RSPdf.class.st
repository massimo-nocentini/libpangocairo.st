Class {
	#name : #RSPdf,
	#superclass : #RSBoundingShape,
	#instVars : [
		'fileReference',
		'pageNumber'
	],
	#category : #Pango
}

{ #category : #creating }
RSPdf class >> allPagesOfFileReference: fileReference [

	| p d uri shape |
	shape := self new.

	uri := shape g_filename_to_uri: fileReference fullName.

	d := shape poppler_document_new_from_file: uri.

	p := [ shape poppler_document_get_n_pages: d ] ensure: [
		     shape gObjectUnref: d ].

	^ self
		  pagesOfFileReference: fileReference
		  from: 1
		  to: (p ifNil: [ 0 ])
]

{ #category : #creating }
RSPdf class >> pagesOfFileReference: fileReference from: from to: to [

	| pages |
	pages := RSGroup new.

	from to: to do: [ :i |
		| pdf |
		pdf := self new
			       fileReference: fileReference;
			       pageNumber: i;
			       yourself.

		pages add: pdf ].

	^ pages
]

{ #category : #visiting }
RSPdf >> accept: visitor [

	visitor visitPdf: self
]

{ #category : #accessing }
RSPdf >> computeEncompassingRectangle [

	| rect |
	self withPopplerPageHandlerDo: [ :popplerPageHandler |
		| w h liblua |
		liblua := LibLua uniqueInstance.
		liblua withOpenedLibsStateDo: [ :L |
			liblua on: L assertLUAOK: [
				liblua
					luaL_requiref: L name: 'cairo';
					on: L push: #cairo;
					lua_getfield: L at: -1 name: 'poppler_page_get_size';
					on: L push: popplerPageHandler;
					lua_pcall: L nargs: 1 nresults: 2 ].

			w := liblua on: L at: -2.
			h := liblua on: L at: -1.

			rect := Rectangle center: 0 @ 0 extent: w @ h ] ].

	^ rect
]

{ #category : #'as yet unclassified' }
RSPdf >> drawOnAthensCairoCanvas: athensCairoCanvas [

	self withPopplerPageHandlerDo: [ :p |
		self poppler_page_render: p cairo: athensCairoCanvas getHandle ]
]

{ #category : #accessing }
RSPdf >> fileReference [

	^ fileReference
]

{ #category : #accessing }
RSPdf >> fileReference: anObject [

	fileReference := anObject
]

{ #category : #'as yet unclassified' }
RSPdf >> gObjectUnref: handler [

	self
		ffiCall: #( void g_object_unref #( void * handler ) )
		module: PopplerLibrary
]

{ #category : #'as yet unclassified' }
RSPdf >> g_filename_to_uri: absoluteFileName [

	^ self
		  ffiCall:
			  #( char #* g_filename_to_uri #( const char #* absoluteFileName
			        #, NULL #, NULL ) )
		  module: PopplerLibrary
]

{ #category : #initialization }
RSPdf >> initialize [

	super initialize.

	self pageNumber: 1
]

{ #category : #accessing }
RSPdf >> pageNumber [

	^ pageNumber
]

{ #category : #accessing }
RSPdf >> pageNumber: anObject [

	pageNumber := anObject
]

{ #category : #'as yet unclassified' }
RSPdf >> poppler_document: document get_page: p [

	^ self
		  ffiCall:
		  #( void #* poppler_document_get_page #( void #* document #, int
		        p ) )
		  module: PopplerLibrary
]

{ #category : #'as yet unclassified' }
RSPdf >> poppler_document_get_n_pages: document [

	^ self
		  ffiCall:
		  #( int poppler_document_get_n_pages #( void #* document ) )
		  module: PopplerLibrary
]

{ #category : #'as yet unclassified' }
RSPdf >> poppler_document_new_from_file: uri [

	^ self
		  ffiCall: #( void #* poppler_document_new_from_file
			     #( const char #* uri #, NULL #, NULL ) )
		  module: PopplerLibrary
]

{ #category : #'as yet unclassified' }
RSPdf >> poppler_page_render: p cairo: cr [

	^ self
		  ffiCall:
		  #( void poppler_page_render #( void #* p #, void #* cr ) )
		  module: PopplerLibrary
]

{ #category : #accessing }
RSPdf >> withPopplerPageHandlerDo: block [

	| p d uri |
	uri := self g_filename_to_uri: self fileReference fullName.

	d := self poppler_document_new_from_file: uri.

	p := self poppler_document: d get_page: self pageNumber - 1.

	[ block value: p ] ensure: [
		self
			gObjectUnref: p;
			gObjectUnref: d ]
]
