Extension { #name : #TextFontChange }

{ #category : #'*Pango' }
TextFontChange >> asPangoAttributeString [

	| logicalFont |
	logicalFont := TextStyle default fontAt: self fontNumber.

	^ 'font-desc "' , logicalFont familyName , ' '
	  , logicalFont pixelSize asString , '"'
]
