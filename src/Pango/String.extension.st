Extension { #name : #String }

{ #category : #'*Pango' }
String >> asRSPangoMarkupUsingFont: font [

	^ self
		  asRSPangoMarkupUsingFont: font
		  withAuxiliaryPangoAttributeSpecs: OrderedCollection new
]

{ #category : #'*Pango' }
String >> asRSPangoMarkupUsingFont: font withAuxiliaryPangoAttributeSpecs: aCollection [

	| markup |
	markup := '<span font_family="{1}" font_size="{2}pt" foreground="black">{3}</span>'
		          format: {
				          font familyName.
				          font pointSize.
				          self }.

	^ RSPangoMarkup new
		  font: font;
		  auxiliaryOrderedLabelLanguageAssociations: aCollection;
		  markup: markup;
		  yourself
]

{ #category : #'*Pango' }
String >> fixEmptyLinesForPango [

	^ Character cr join:
		  (self lines collect: [ :l | l ifEmpty: [ self class space ] ])
]

{ #category : #'*Pango' }
String >> replaceAllTabsWithSpacesForPango [

	^ self
		  copyReplaceAll: self class tab
		  with: (self class space repeat: 3)
]
