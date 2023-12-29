Class {
	#name : 'RSPangoMarkup',
	#superclass : 'RSPangoText',
	#classVars : [
		'Conversions'
	],
	#category : 'Pango',
	#package : 'Pango'
}

{ #category : 'initialization' }
RSPangoMarkup class >> initialize [

	Conversions := Dictionary new
		               at: '\infty' put: '&#8734;';
		               at: '\forall' put: '&#8704;';
		               at: '\thereexists' put: '&#8707;';
		               at: '\elementof' put: '&#8712;';
		               at: '\minussign' put: '&#8722;';
		               at: '\alpha' put: '&#0945;';
		               at: '\bullet' put: '&#8226;';
		               at: '\whitecircle' put: '&#9633;';
		               at: '\blackcircle' put: '&#9635;';
		               yourself
]

{ #category : 'accessing' }
RSPangoMarkup >> markup: aString [

	^ self text: aString
]

{ #category : 'ffi bindings' }
RSPangoMarkup >> onPangoLayout: layoutHandler setAttrListHandler: attrListHandler [

	
]

{ #category : 'ffi bindings' }
RSPangoMarkup >> onPangoLayout: layoutHandler setText: aString [

	<primitive: 'primitive_pango_layout_set_markup' module:
	'CairoGraphicsPlugin'>
	self primitiveFail
]

{ #category : 'accessing' }
RSPangoMarkup >> text: aString [

	| markupString |
	markupString := String streamContents: [ :stream |
		                stream
			                << '<markup>';
			                << '<span font_family="';
			                << self font familyName;
			                << '" font_size="';
			                << self font pointSize asString;
			                << 'pt" foreground="#';
			                << self defaultForegroundColor asHexString;
			                << '">';
			                << aString fixEmptyLinesForPango asUTF8String;
			                << '</span>';
			                << '</markup>' ].

	^ super text: markupString
]

{ #category : 'handle' }
RSPangoMarkup >> withPangoAttrList [

	^ self newPangoAttrListHandler
]
