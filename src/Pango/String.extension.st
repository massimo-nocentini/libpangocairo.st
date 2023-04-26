Extension { #name : #String }

{ #category : #'*Pango' }
String >> asRSPangoMarkupUsingFont: font [

	| markup |
	markup := '<span font_family="{1}" font_size="{2}pt" foreground="black">{3}</span>'
		          format: {
				          font familyName.
				          font pointSize.
				          self }.

	^ RSPangoMarkup new
		  font: font;
		  markup: markup;
		  yourself
]

{ #category : #'*Pango' }
String >> fixEmptyLinesForPango [

	^ Character cr join:
		  (self lines collect: [ :l | l ifEmpty: [ Character space ] ])
]

{ #category : #'*Pango' }
String >> pango_attr_list_from_string [

	^ PangoAttrList attr_list_from_string: self
]

{ #category : #'*Pango' }
String >> replaceAllTabsWithSpacesForPango [

	^ self
		  copyReplaceAll: self class tab
		  with: (self class space repeat: 3)
]
