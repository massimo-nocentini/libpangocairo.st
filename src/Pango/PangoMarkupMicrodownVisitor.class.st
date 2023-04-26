Class {
	#name : #PangoMarkupMicrodownVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'stream',
		'nestedLevel',
		'levels',
		'sectionsNumbering'
	],
	#category : #Pango
}

{ #category : #accessing }
PangoMarkupMicrodownVisitor >> << aString [

	stream
		<< (String tab repeat: nestedLevel);
		<< aString
]

{ #category : #initialization }
PangoMarkupMicrodownVisitor >> initialize [

	super initialize.

	nestedLevel := 0.

	levels := OrderedCollection with: 42.
	1 to: 5 do: [ :i | levels add: (levels at: i) / Float goldenRatio ].

	sectionsNumbering := Dictionary new
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> pointSizeForHeaderLevel: l [

	^ levels at: l ifAbsent: [ levels last ]
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
		<< '</span> '.

	super visitMathInline: aMicMathInline
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMonospace: aFormat [

	stream << ' <span font_family="Source Code Pro">'.

	super visitMonospace: aFormat.

	stream << '</span> '
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

	stream << ' <span strikethrough="true">'.

	super visitStrike: aFormat.

	stream << '</span> '
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitText: aMicTextBlock [

	| lines |
	lines := aMicTextBlock substring lines.

	stream << lines first trim.

	2 to: lines size do: [ :i |
		stream << String cr.

		self << '<span foreground="white">\bullet</span> '.

		stream << (lines at: i) trim ].

	super visitText: aMicTextBlock
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitUnorderedList: anUnorderedList [

	| prevLevel |
	prevLevel := nestedLevel.

	nestedLevel := anUnorderedList nestedLevel.

	nestedLevel > 1 ifTrue: [ stream << String cr ].

	super visitUnorderedList: anUnorderedList.

	nestedLevel = 1 ifTrue: [ stream << String cr ].

	stream << String cr.

	nestedLevel := prevLevel
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitUnorderedListItem: anUnorderedList [

	stream << String cr.

	self << '\bullet '.

	super visitUnorderedListItem: anUnorderedList
]
