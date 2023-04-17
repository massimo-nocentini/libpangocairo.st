Class {
	#name : #PangoMarkupMicrodownVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'stream',
		'nestedLevel'
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

	nestedLevel := 0
]

{ #category : #'as yet unclassified' }
PangoMarkupMicrodownVisitor >> visit: mic [

	^ (String streamContents: [ :aStream |
		   stream := aStream. "save the reference and continue visiting."

		   super visit: mic ]) trim
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMonospace: aFormat [

	stream << ' <tt>'.

	super visitMonospace: aFormat.

	stream << '</tt> '
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
PangoMarkupMicrodownVisitor >> visitText: aMicTextBlock [

	| lines |
	lines := aMicTextBlock substring lines.

	stream << lines first trim.

	2 to: lines size do: [ :i |
		stream << String cr.

		self << '<span foreground="white">&#8226;</span> '.

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

	self << '&#8226; '.

	super visitUnorderedListItem: anUnorderedList
]
