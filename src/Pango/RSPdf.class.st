Class {
	#name : #RSPdf,
	#superclass : #RSBoundingShape,
	#category : #Pango
}

{ #category : #visiting }
RSPdf >> accept: visitor [

	visitor visitPdf: self
]

{ #category : #accessing }
RSPdf >> computeEncompassingRectangle [

	^ self onAthensCairoCanvas: nil show: false
]

{ #category : #accessing }
RSPdf >> onAthensCairoCanvas: athensCanvas show: requestLogicalRectangle [

	| liblua |
	liblua := LibLua uniqueInstance.

	^ liblua withOpenedLibsStateDo: [ :L |
		  | w h |
		  liblua on: L assertLUAOK: [
			  liblua
				  luaL_requiref: L name: 'cairo';
				  on: L push: #cairo;
				  lua_getfield: L at: -1 name: 'poppler_document_new_from_file';
				  on: L push: athensCanvas;
				  on: L
				  push: '/home/mn/Downloads/Schmidt time table - April 2023.pdf';
				  on: L push: 1;
				  on: L push: requestLogicalRectangle;
				  lua_pcall: L nargs: 4 nresults: 2 ].

		  w := liblua on: L at: -2.
		  h := liblua on: L at: -1.

		  Rectangle center: 0 @ 0 extent: w @ h ]
]
