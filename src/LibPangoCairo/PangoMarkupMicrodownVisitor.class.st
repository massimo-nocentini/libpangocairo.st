Class {
	#name : 'PangoMarkupMicrodownVisitor',
	#superclass : 'MicrodownVisitor',
	#instVars : [
		'stream',
		'nestedLevel',
		'levels',
		'sectionsNumbering',
		'modifier',
		'orderedNestedLevels',
		'auxiliaryOrderedLabelLanguageAssociations',
		'fontMonospace',
		'fontSans',
		'pangoMarkup',
		'lastMicBlock',
		'footers',
		'codePresenter'
	],
	#classVars : [
		'UnorderedBullets'
	],
	#category : 'LibPangoCairo-Microdown',
	#package : 'LibPangoCairo',
	#tag : 'Microdown'
}

{ #category : 'class initialization' }
PangoMarkupMicrodownVisitor class >> initialize [

	UnorderedBullets := { '&#9679;'. '&#9675;'. '&#9632;'. '&#9633;'.
	                    '&#9654;'. '&#9655;'. '&#9733;'. '&#9734;' }
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> appendFooterNamed: groupName label: label shape: tsText [

	| associations l |
	associations := footers at: groupName.

	l := label , String space , (associations size + 1) asString.

	associations add: l -> tsText.

	^ l
]

{ #category : 'converting' }
PangoMarkupMicrodownVisitor >> asRSPangoShapeUsingFont: font [

	| composite footerShapes |
	composite := RSPangoMarkup new
		             font: font;
		             text: pangoMarkup;
		             yourself.

	footerShapes := self treeSitterLanguageShapesWithFont:
		                PangoLogicalFontManager pangoMonospace.

	footerShapes ifNotEmpty: [
		composite := RSGroup new
			             add: composite;
			             addAll: footerShapes;
			             yourself.

		RSVerticalLineLayout new
			verticalGap: Float goldenRatio;
			alignLeft;
			on: composite.

		composite := composite asShape ].

	^ composite
]

{ #category : 'accessing' }
PangoMarkupMicrodownVisitor >> bulletAtCurrentNestedLevel [

	^ nestedLevel > 0
		  ifTrue: [
			  (UnorderedBullets at: nestedLevel ifAbsent: [ '\#9671;' ])
			  , String space ]
		  ifFalse: [ '' ]
]

{ #category : 'accessing' }
PangoMarkupMicrodownVisitor >> codePresenter [

	^ codePresenter
]

{ #category : 'accessing' }
PangoMarkupMicrodownVisitor >> codePresenter: anObject [

	codePresenter := anObject
]

{ #category : 'accessing' }
PangoMarkupMicrodownVisitor >> docClassOptionsOfMicMathBlock: aMicMath [

	^ aMicMath arguments
		  at: #texDocClassOptions
		  ifAbsent: [
		  PangoLogicalFontManager pangoMath pointSize asString , 'pt' ]
]

{ #category : 'initialization' }
PangoMarkupMicrodownVisitor >> footerNames [

	| dict |
	dict := Dictionary new.
	#( link math code note eval figure ) do: [ :footerName |
		dict at: footerName put: OrderedCollection new ].
	^ dict
]

{ #category : 'testing' }
PangoMarkupMicrodownVisitor >> hasFooter [

	^ footers values
		  inject: false
		  into: [ :aBoolean :associations |
		  aBoolean | associations isNotEmpty ]
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> indentationString [

	^ '   '
]

{ #category : 'initialization' }
PangoMarkupMicrodownVisitor >> initialize [

	super initialize.

	nestedLevel := 0.

	levels := OrderedCollection with: 42.
	1 to: 5 do: [ :i | levels add: (levels at: i) / Float goldenRatio ].

	sectionsNumbering := Dictionary new.

	orderedNestedLevels := Dictionary new.

	modifier := nil.

	footers := self footerNames.

	fontMonospace := PangoLogicalFontManager pangoMonospace.
	fontSans := PangoLogicalFontManager pangoSans.

	self codePresenter: (SpCodePresenter new
			 beForScripting;
			 yourself)
]

{ #category : 'accessing' }
PangoMarkupMicrodownVisitor >> nextPutAllAlpha: alpha mod: link [

	link ifNotNil: [
		self nextPutAllAlpha: 1 mod: link nextLink.

		stream
			nextPutAll: self indentationString;
			nextPutAll: ('<span alpha="{1}%">{2}</span>' format: {
							 (alpha asInteger min: 100 max: 1).
							 link value }) ]
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> pointSizeForHeaderLevel: l [

	^ levels at: l ifAbsent: [ levels last ]
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> popModifier [

	modifier := modifier nextLink.

	^ modifier
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> pushModifier: aString [

	modifier := ValueLink new
		            value: aString;
		            nextLink: modifier;
		            yourself.

	^ modifier
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> texChunkOfMicMathBlock: aMicMath [

	| texEnv |
	texEnv := aMicMath arguments
		          at: #texEnv
		          ifPresent: [ :texEnvName | texEnvName asSymbol ]
		          ifAbsent: [ #eq ].

	texEnv = #eq ifTrue: [ ^ PopplerTeXDisplayStyleChunk new ].
	texEnv = #tikZ ifTrue: [ ^ PopplerTikZChunk new ].

	^ PopplerTeXChunk new "otherwise."
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> treeSitterLanguageShapesWithFont: aFont [

	| shapes maxWidth layout location vLayout |
	maxWidth := 0.0.
	shapes := OrderedCollection new.

	footers keysAndValuesDo: [ :groupName :associations |
		associations ifNotEmpty: [
			associations do: [ :assoc |
				| labelShape chunkShape group |
				labelShape := RSPangoMarkup new
					              font: fontSans;
					              text: (String streamContents: [ :s |
								               s
									               << '<span font_size="smaller" alpha="50%">[';
									               << assoc key;
									               << ']';
									               << '</span>' ]);
					              asCompositeShape. "necessary because of the alignment step at the bottom."

				chunkShape := assoc value asRSPangoShapeUsingFont: aFont.

				maxWidth := maxWidth max: labelShape width.

				group := RSGroup new
					         add: labelShape;
					         add: chunkShape;
					         yourself.

				shapes add: group ] ] ].

	"Now that we have the `maxWidth` we can setup the layout object."
	layout := RSHorizontalLineLayout new
		          horizontalGap: maxWidth * Float silverRatio;
		          alignMiddle;
		          yourself.

	location := RSLocation new
		            left;
		            yourself.

	vLayout := RSVerticalLineLayout new
		           verticalGap: Float goldenRatio;
		           yourself.

	^ shapes collect: [ :group |
		  | composite g |
		  composite := group first
			               width: maxWidth;
			               yourself.

		  "Ensure that the Pango shape for the label is positioned on the left margin."
		  location move: composite shapes first on: composite.

		  layout on: group. "Put the label and the chunk shapes on the same line."

		  composite := group asShape.

		  g := RSGroup new
			       add: (RSLine new
					        startPoint: 0 @ 0;
					        endPoint: composite width + Float goldenRatio @ 0.0;
					        color: (Smalltalk ui theme borderColor alpha: 0.5);
					        capRound;
					        yourself);
			       add: composite;
			       yourself.

		  vLayout on: g.

		  g asShape ]
]

{ #category : 'visiting main API' }
PangoMarkupMicrodownVisitor >> visit: mic [
	"Cleanup before starting a new visit."

	footers keysAndValuesDo: [ :groupName :associations |
		associations removeAll ].

	lastMicBlock := nil.

	pangoMarkup := (String streamContents: [ :aStream |
		                stream := aStream. "save the reference and continue visiting."

		                super visit: mic.

		                stream := nil "Clean it up" ]) trim.

	^ pangoMarkup
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitBold: aFormat [

	stream << '<span weight="bold">'.

	super visitBold: aFormat.

	stream << '</span>'.

	lastMicBlock := aFormat
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitCode: aCodeBlock [

	| label tsText |
	tsText := TSChunk new
		          language: aCodeBlock language;
		          sourceCode: aCodeBlock code;
		          yourself.

	label := self appendFooterNamed: #code label: 'Listing' shape: tsText.

	stream
		<< String space;
		<< '<i>'.
	super visitCode: aCodeBlock.
	stream << '</i>'.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< label;
		<< ']</span></span>'.

	lastMicBlock := aCodeBlock
]

{ #category : 'visiting - inline elements' }
PangoMarkupMicrodownVisitor >> visitFigure: aFigure [

	| label pangoMicFigure |
	pangoMicFigure := PangoMicFigure new
		                  micHttpResource: aFigure reference;
		                  yourself.

	label := self
		         appendFooterNamed: #figure
		         label: 'Figure'
		         shape: pangoMicFigure.

	stream
		<< String space;
		<< '<i>'.
	super visitFigure: aFigure.
	stream << '</i>'.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< label;
		<< ']</span></span>'.

	lastMicBlock := aFigure
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitFootnote: aFootnote [

	| label note |
	note := String streamContents: [ :noteStream |
		        noteStream
			        << '<span font_family="';
			        << PangoLogicalFontManager pangoSerif familyName;
			        << '" font_size="smaller">';
			        << aFootnote note;
			        << '</span>' ].

	label := self appendFooterNamed: #note label: 'Note' shape: note.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< label;
		<< ']</span></span>'.

	lastMicBlock := aFootnote
]

{ #category : 'visiting' }
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
			                 | num |
			                 num := sectionsNumbering
				                        at: k
				                        ifAbsentPut: [ " Warning signal:
									                  'Use a level more in depth than expected.'."
					                        1 ].
			                 s
				                 << num asString;
				                 << '.' ] ].

	stream
		<< String cr;
		<< String cr;
		<< ('<span font_family="{1}" font_size="{2}pt">{3} ' format: {
						 fontSans familyName.
						 (self pointSizeForHeaderLevel: aHeader level).

						 sectionNumber }).

	super visitHeader: aHeader.

	stream
		<< '</span>';
		<< String cr.

	lastMicBlock := aHeader
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitInputFile: anInputFileMicBlock [

	^ anInputFileMicBlock arguments
		  at: #language
		  ifPresent: [ :language | "Put an header before the actual resource content."
			  stream
				  cr;
				  space;
				  cr;
				  <<
					  '<span size="larger" style="italic" underline="single" foreground="gray" font_family="';
				  << fontMonospace familyName;
				  << '">';
				  << anInputFileMicBlock reference fullName;
				  << '</span>'.

			  anInputFileMicBlock reference contents
				  ifEmpty: [ super visitInputFile: anInputFileMicBlock ]
				  ifNotEmpty: [ :content |
					  | codeMicBlock |
					  codeMicBlock := MicCodeBlock new
						                  body: content;
						                  yourself.

					  codeMicBlock arguments at: #language put: language.

					  codeMicBlock accept: self ] ]
		  ifAbsent: [ super visitInputFile: anInputFileMicBlock ]
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitItalic: aFormat [

	stream << '<span font_style="italic">'.

	super visitItalic: aFormat.

	stream << '</span>'
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitLink: aLink [

	| label |
	label := self
		         appendFooterNamed: #link
		         label: 'Link'
		         shape: aLink url asUrl.

	stream
		<< String space;
		<< '<i>'.
	super visitLink: aLink.
	stream << '</i>'.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< label;
		<< ']</span></span>'.

	lastMicBlock := aLink
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitMath: aMicMath [

	| label texChunk docClassOptions |
	texChunk := self texChunkOfMicMathBlock: aMicMath.
	docClassOptions := self docClassOptionsOfMicMathBlock: aMicMath.

	"Prepare the chunk object with the provided customizations."
	texChunk
		commaSeparatedDocClassOptionsString: docClassOptions;
		chunk: aMicMath body.

	label := self appendFooterNamed: #math label: 'Math' shape: texChunk.

	stream
		<< String space;
		<< '<i>'.
	super visitMath: aMicMath.
	stream << '</i>'.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< label;
		<< ']</span></span>'.

	lastMicBlock := aMicMath
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitMathInline: aMicMathInline [

	stream
		<< '<span font_family="';
		<< PangoLogicalFontManager pangoMath familyName;
		<< '">';
		<< aMicMathInline bodyString;
		<< '</span>'.

	super visitMathInline: aMicMathInline
]

{ #category : 'visiting - inline elements' }
PangoMarkupMicrodownVisitor >> visitMonospace: aFormat [

	stream
		<< '<span font_family="';
		<< fontMonospace familyName;
		<< '" background="gray" bgalpha="31%">'.

	super visitMonospace: aFormat.

	stream << '</span>'
]

{ #category : 'visiting' }
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

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitParagraph: aParagraph [

	lastMicBlock
		appendCarriageReturnsOnStream: stream
		nextParagraph: self.

	stream << '<span>'.

	super visitParagraph: aParagraph.

	stream << '</span>'.

	lastMicBlock := aParagraph
]

{ #category : 'visiting - extensions' }
PangoMarkupMicrodownVisitor >> visitPharoEvaluator: aPharoEvalBlock [

	| obj label |
	obj := PangoPharoEvaluator new
		       evaluator: self codePresenter;
		       source: aPharoEvalBlock body;
		       yourself.

	label := self appendFooterNamed: #eval label: 'Eval' shape: obj.

	stream
		<< String space;
		<< '<i>'.
	super visitPharoEvaluator: aPharoEvalBlock.
	stream << '</i>'.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< label;
		<< ']</span></span>'.

	lastMicBlock := aPharoEvalBlock
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitQuote: aQuote [

	self withOneNestedLevelMoreDo: [
		stream << String cr.

		self pushModifier: '&#8220; '.

		stream << '<span font_size="smaller" font_style="italic">'.

		self nextPutAllAlpha: 100 mod: modifier.

		super visitQuote: aQuote.

		stream
			<< ' &#8220;';
			<< '</span>';
			cr.

		self popModifier ]
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitRaw: aRaw [

	stream << aRaw bodyString.

	super visitRaw: aRaw
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitStrike: aFormat [

	stream << '<span strikethrough="true">'.

	super visitStrike: aFormat.

	stream << '</span>'
]

{ #category : 'visiting - inline elements' }
PangoMarkupMicrodownVisitor >> visitText: aMicTextBlock [

	aMicTextBlock text lines ifNotEmpty: [ :lines |
		stream nextPutAll: lines first gMarkupEscapeText.

		2 to: lines size do: [ :i |
			stream cr.

			self nextPutAllAlpha: (i = 1) asBit * 100 mod: modifier.

			stream nextPutAll: (lines at: i) gMarkupEscapeText ] ].

	super visitText: aMicTextBlock
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitUnorderedList: anUnorderedList [

	self withOneNestedLevelMoreDo: [
		super visitUnorderedList: anUnorderedList ]
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> visitUnorderedListItem: anUnorderedList [

	self pushModifier: self bulletAtCurrentNestedLevel.

	stream cr.

	self nextPutAllAlpha: 100 mod: modifier.

	super visitUnorderedListItem: anUnorderedList.

	self popModifier
]

{ #category : 'visiting' }
PangoMarkupMicrodownVisitor >> withOneNestedLevelMoreDo: aBlock [

	nestedLevel := nestedLevel + 1.

	aBlock value.

	nestedLevel := nestedLevel - 1
]
