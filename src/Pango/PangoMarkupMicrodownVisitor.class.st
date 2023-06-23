Class {
	#name : #PangoMarkupMicrodownVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'stream',
		'nestedLevel',
		'levels',
		'sectionsNumbering',
		'modifier',
		'orderedNestedLevels',
		'footers',
		'linksCount',
		'maxFooterSize',
		'codeLabelRandom',
		'increasingCodeLabel',
		'auxiliaryOrderedLabelLanguageAssociations',
		'fontMonospace',
		'fontSans',
		'fontSerif',
		'fontMath'
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

{ #category : #'as yet unclassified' }
PangoMarkupMicrodownVisitor >> appendFooters [

	footers ifNotEmpty: [
		stream cr.

		maxFooterSize timesRepeat: [ stream << '_' ].

		footers do: [ :assoc |
			stream
				cr;
				<< '<span font_family="';
				<< fontSans familyName;
				<< '" font_size="smaller" alpha="50%">[';
				<< assoc key asString;
				<< '] <span alpha="100%">';
				<< assoc value;
				<< '</span></span>' ].

		footers removeAll.
		maxFooterSize := 0 ]
]

{ #category : #accessing }
PangoMarkupMicrodownVisitor >> auxiliaryOrderedLabelLanguageAssociations: aCollection [

	auxiliaryOrderedLabelLanguageAssociations := aCollection
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
PangoMarkupMicrodownVisitor >> escapeTextInGMarkup: code [

	^ self withNewLuaStateDo: [ :L :ll |
		  | retcode |
		  retcode := ll
			             luaL_requiref: L name: 'cairo';
			             on: L push: #cairo;
			             lua_getfield: L
			             at: -1
			             name: 'g_markup_escape_text'
			             remove: true;
			             on: L push: code;
			             lua_pcall: L nargs: 1 nresults: 1.

		  self
			  assert: retcode == ll LUA_OK
			  description: 'failed to escape text.'.

		  ll on: L at: -1 ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> highlightsMatches: srcString language: language do: recv [

	^ self withNewLuaStateDo: [ :L :ll |
		  | retcode matches srcLines |
		  retcode := ll
			             luaL_requiref: L name: 'tree-sitter';
			             on: L push: #'tree-sitter';
			             lua_getfield: L
			             at: -1
			             name: 'highlights_matches'
			             remove: true;
			             on: L push: language;
			             on: L push: srcString;
			             lua_pcall: L nargs: 2 nresults: 2.

		  self
			  assert: retcode == ll LUA_OK
			  description: 'failed to compute highlights.'.

		  matches := ll on: L at: -2.
		  srcLines := ll on: L at: -1.

		  matches ifNotNil: [ recv value: matches value: srcLines ] ]
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

	modifier := nil.

	footers := OrderedCollection new.

	linksCount := 0.

	maxFooterSize := 0.

	codeLabelRandom := Random seed: 541.

	increasingCodeLabel := 0.0.

	fontMonospace := LogicalFont pangoMonospace.
	fontSans := LogicalFont pangoSans.
	fontSerif := LogicalFont pangoSerif.
	fontMath := LogicalFont pangoMath
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> nextCodeLabel [

	increasingCodeLabel := increasingCodeLabel + codeLabelRandom next.

	^ '.. code::'
	  , (increasingCodeLabel asString copyReplaceAll: '.' with: '')
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
PangoMarkupMicrodownVisitor >> postFooter: micElement do: block [

	| assoc str |
	linksCount := linksCount + 1.
	str := micElement asFooterStringForPangoMarkupMicrodownVisitor: self.

	maxFooterSize := maxFooterSize max: str size.

	assoc := linksCount -> str.

	footers add: assoc.

	block value.

	stream
		<< String space;
		<< '<span baseline_shift="superscript"><span font_family="';
		<< fontSans familyName;
		<< '" font_size="smaller" alpha="50%">[';
		<< assoc key asString;
		<< ']</span></span>'
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

		   super visit: mic.

		   self appendFooters.

		   stream := nil "Clean it up" ]) trim
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitBold: aFormat [

	stream << '<span weight="bold">'.

	super visitBold: aFormat.

	stream << '</span>'
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitCode: aCodeBlock [

	| code label |
	label := self nextCodeLabel.

	stream cr. "introduce a new line"

	"to make the label invisible, this will look like to have an empty line."
	stream
		<< '<span alpha="1">';
		<< label;
		<< '</span>';
		cr.

	(stream << '<span font_family="')
		<< fontMonospace familyName;
		<< '">'.

	"Prepare the code source to remove Smalltalk stuff about comments."
	code := aCodeBlock code trim copyReplaceAll: '""' with: '"'.

	code := code withInternalLineEndings
		        fixEmptyLinesForPangoUsingJoiner: Character lf.

	self assert: (code lines select: #isEmpty) isEmpty.

	self
		highlightsMatches: code
		language: aCodeBlock language
		do: [ :matches :codeLines |
			| language |
			self assert: (codeLines select: #isEmpty) isEmpty.

			code := Character cr join: codeLines.

			language := aCodeBlock language asSymbol value: TSLanguage.

			language matches: matches.

			auxiliaryOrderedLabelLanguageAssociations add: label -> language ].

	code := self escapeTextInGMarkup: code.

	stream
		<< code;
		<< '</span>';
		cr.

	^ super visitCode: aCodeBlock
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitFootnote: aFootnote [

	self postFooter: aFootnote do: [  ]
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
		<< String cr;
		<< ('<span font_family="{1}" font_size="{2}pt">{3} ' format: {
						 fontSans familyName.
						 (self pointSizeForHeaderLevel: aHeader level).

						 sectionNumber }).

	super visitHeader: aHeader.

	stream
		<< '</span>';
		<< String cr
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitInputFile: anInputFileMicBlock [

	^ anInputFileMicBlock arguments
		  at: #language
		  ifPresent: [ :language | "Put an header before the actual resource content."
			  stream
				  cr;
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

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitItalic: aFormat [

	stream << '<span font_style="italic">'.

	super visitItalic: aFormat.

	stream << '</span>'
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitLink: aLink [

	self postFooter: aLink do: [
		stream << '<i>'.

		super visitLink: aLink.

		stream << '</i>' ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMath: aMicMath [

	self notYetImplemented
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMathInline: aMicMathInline [

	stream
		<< '<span font_family="';
		<< fontMath familyName;
		<< '">';
		<< aMicMathInline text;
		<< '</span>'.

	super visitMathInline: aMicMathInline
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitMonospace: aFormat [

	stream
		<< '<span font_family="';
		<< fontMonospace familyName;
		<< '" background="gray" bgalpha="31%">'.

	super visitMonospace: aFormat.

	stream << '</span>'
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

	stream
		cr;
		cr;
		<< '<span>'.

	super visitParagraph: aParagraph.

	stream << '</span>'
]

{ #category : #visiting }
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

	self withOneNestedLevelMoreDo: [
		super visitUnorderedList: anUnorderedList ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> visitUnorderedListItem: anUnorderedList [

	self pushModifier: self bulletAtCurrentNestedLevel.

	stream cr.

	self nextPutAllAlpha: 100 mod: modifier.

	super visitUnorderedListItem: anUnorderedList.

	self popModifier
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> withNewLuaStateDo: aCodeBlock [

	| ll |
	ll := LibLua uniqueInstance.

	^ ll withOpenedLibsStateDo: [ :L | aCodeBlock value: L value: ll ]
]

{ #category : #visiting }
PangoMarkupMicrodownVisitor >> withOneNestedLevelMoreDo: aBlock [

	nestedLevel := nestedLevel + 1.

	aBlock value.

	nestedLevel := nestedLevel - 1
]
