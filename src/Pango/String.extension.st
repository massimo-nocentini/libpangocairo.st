Extension { #name : 'String' }

{ #category : '*Pango' }
String >> asRSPangoShapeUsingFont: font [

	^ RSPangoMarkup new
		  font: font;
		  markup: self;
		  asCompositeShape
]

{ #category : '*Pango' }
String >> fixEmptyLinesForPango [

	^ self fixEmptyLinesForPangoUsingJoiner: Character cr
]

{ #category : '*Pango' }
String >> fixEmptyLinesForPangoUsingJoiner: joiner [

	^ joiner join: ((Character cr split: self) collect: [ :l |
			   l ifEmpty: [ self class space ] ])
]

{ #category : '*Pango' }
String >> gmarkupEscapeText [
	"https://docs.gtk.org/glib/func.markup_escape_text.html"

	^ self
		  ffiCall:
		  #( char #* g_markup_escape_text #( char #* self #, int -1 ) )
		  module: PangoLibrary
]

{ #category : '*Pango' }
String >> replaceAllTabsWithSpacesForPango [

	^ self
		  copyReplaceAll: self class tab
		  with: (self class space repeat: 3)
]

{ #category : '*Pango' }
String >> shStyleElement [

	^ SHStyleElement withTokens: #( string )
]
