Class {
	#name : #PangoMarkupMicrodownVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'stream',
		'nestedLevel',
		'levels',
		'sectionsNumbering',
		'modifier',
		'orderedNestedLevels'
	],
	#classVars : [
		'UnorderedBullets'
	],
	#category : #Pango
}

{ #category : #'class initialization' }
PangoMarkupMicrodownVisitor class >> initialize [

	UnorderedBullets := { '&#9679;'. '&#9675;'. '&#9632;'. '&#9633;'.
	                    '&#9654;'. '&#9655;'. '&#9733;'. '&#9734;' }
]

{ #category : #accessing }
PangoMarkupMicrodownVisitor >> bulletAtCurrentNestedLevel [

	^ nestedLevel > 0
		  ifTrue: [
			  (UnorderedBullets at: nestedLevel ifAbsent: [ '\#9671;' ])
			  , String space ]
		  ifFalse: [ '' ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> indentationString [

	^ '   '
]

{ #category : #initialization }
PangoMarkupMicrodownVisitor >> initialize [

	super initialize.

	nestedLevel := 0.

	levels := OrderedCollection with: 42.
	1 to: 5 do: [ :i | levels add: (levels at: i) / Float goldenRatio ].

	sectionsNumbering := Dictionary new.

	orderedNestedLevels := Dictionary new.

	modifier := nil
]

{ #category : #accessing }
PangoMarkupMicrodownVisitor >> nextPutAllAlpha: alpha mod: link [

	link ifNotNil: [
		self nextPutAllAlpha: 1 mod: link nextLink.

		stream
			nextPutAll: self indentationString;
			nextPutAll: ('<span alpha="{1}%">{2}</span>' format: {
							 (alpha asInteger min: 100 max: 1).
							 link value }) ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> pointSizeForHeaderLevel: l [

	^ levels at: l ifAbsent: [ levels last ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> popModifier [

	modifier := modifier nextLink.

	^ modifier
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> pushModifier: aString [

	modifier := ValueLink new
		            value: aString;
		            nextLink: modifier;
		            yourself.

	^ modifier
]

{ #category : #'as yet unclassified' }
PangoMarkupMicrodownVisitor >> visit: mic [

	^ (String streamContents: [ :aStream |
		   stream := aStream. "save the reference and continue visiting."

		   super visit: mic ]) trim
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitBold: aFormat [

	stream << ' <span weight="bold">'.

	super visitBold: aFormat.

	stream << '</span> '
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitHeader: aHeader [

	| sectionNumber l |
	l := aHeader level.

	sectionsNumbering
		at: l
		ifPresent: [ :n |
			sectionsNumbering at: l put: n + 1.

			l + 1 to: sectionsNumbering size do: [ :k |
			sectionsNumbering removeKey: k ] ]
		ifAbsentPut: [ 1 ].

	sectionNumber := String streamContents: [ :s |
		                 1 to: l do: [ :k |
			                 s
				                 << (sectionsNumbering at: k ifAbsent: [
							                  Warning signal:
									                  'Use a level more in depth than expected.'.
							                  0 ]) asString;
				                 << '.' ] ].

	stream
		<< String cr;
		<< ('<span font_family="{1}" font_size="{2}pt">{3} ' format: {
						 LogicalFont fontconfigPharoSansPointSize familyName.
						 (self pointSizeForHeaderLevel: aHeader level).

						 sectionNumber }).

	super visitHeader: aHeader.

	stream
		<< '</span>';
		<< String cr;
		<< String cr
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitItalic: aFormat [

	stream << ' <span font_style="italic">'.

	super visitItalic: aFormat.

	stream << '</span> '
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMath: aMicMath [

	stream << String cr.

	self
		<< '<span font_family="Neo Euler">';
		<< aMicMath body trim;
		<< '</span>'.

	super visitMath: aMicMath
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMathInline: aMicMathInline [

	stream
		<< String space;
		<< '<span font_family="Neo Euler">';
		<< aMicMathInline text trim;
		<< '</span>';
		<< String space.

	super visitMathInline: aMicMathInline
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMonospace: aFormat [

	stream << ' <span font_family="Source Code Pro">'.

	super visitMonospace: aFormat.

	stream << '</span> '
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitOrderedList: anOrderedList [

	| prevLevel |
	prevLevel := nestedLevel.

	nestedLevel := anOrderedList nestedLevel.

	super visitOrderedList: anOrderedList.

	nestedLevel := prevLevel
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitOrderedListItem: anOrderedItem [

	| mod prevLevel item stack |
	item := anOrderedItem parent.

	prevLevel := orderedNestedLevels at: item ifAbsent: [ 0 ].

	orderedNestedLevels at: item put: prevLevel + 1.

	stack := nil.

	[ item isNotNil ] whileTrue: [
		orderedNestedLevels at: item ifPresent: [ :p |
			stack := ValueLink new
				         value: p asString;
				         nextLink: stack;
				         yourself ].

		item := item parent ].

	mod := String streamContents: [ :s |
		       [ stack isNotNil ] whileTrue: [
			       s << (stack value , '.').
			       stack := stack nextLink ] ].

	self pushModifier: mod , String space.

	stream cr.

	self nextPutAllAlpha: 100 mod: modifier.

	super visitOrderedListItem: anOrderedItem.

	self popModifier
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitParagraph: aParagraph [

	stream << '<span>'.

	super visitParagraph: aParagraph.

	stream
		<< '</span>';
		<< String cr
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitQuote: aQuote [

	self halt.
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitStrike: aFormat [

	stream << '<span strikethrough="true">'.

	super visitStrike: aFormat.

	stream << '</span>'
]

{ #category : #'visiting - inline elements' }
PangoMarkupMicrodownVisitor >> visitText: aMicTextBlock [

	aMicTextBlock text lines ifNotEmpty: [ :lines |
		stream nextPutAll: lines first.


		2 to: lines size do: [ :i |
			stream cr.

			self nextPutAllAlpha: (i = 1) asBit * 100 mod: modifier.

			stream nextPutAll: (lines at: i) ] ].

	super visitText: aMicTextBlock
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitUnorderedList: anUnorderedList [

	| prevLevel |
	prevLevel := nestedLevel.

	nestedLevel := anUnorderedList nestedLevel.

	"nestedLevel > 1 ifTrue: [ stream << String cr ]."

	super visitUnorderedList: anUnorderedList.

	"nestedLevel = 1 ifTrue: [ stream << String cr ]."

	"stream << String cr."

	nestedLevel := prevLevel
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitUnorderedListItem: anUnorderedList [

	self pushModifier: self bulletAtCurrentNestedLevel.

	stream cr.

	self nextPutAllAlpha: 100 mod: modifier.

	super visitUnorderedListItem: anUnorderedList.

	self popModifier
]
