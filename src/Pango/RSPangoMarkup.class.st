Class {
	#name : #RSPangoMarkup,
	#superclass : #RSPangoText,
	#instVars : [
		'markup',
		'auxiliaryOrderedLabelLanguageAssociations'
	],
	#classVars : [
		'Conversions'
	],
	#category : #Pango
}

{ #category : #initialization }
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

{ #category : #accessing }
RSPangoMarkup >> auxiliaryOrderedLabelLanguageAssociations: anObject [

	auxiliaryOrderedLabelLanguageAssociations := anObject
]

{ #category : #accessing }
RSPangoMarkup >> convertMacros: aString [

	| converted |
	converted := aString.

	Conversions keysAndValuesDo: [ :macro :replacement |
		converted := converted copyReplaceAll: macro with: replacement ].

	^ converted
]

{ #category : #initialization }
RSPangoMarkup >> initialize [

	super initialize.

	self auxiliaryOrderedLabelLanguageAssociations: OrderedCollection new
]

{ #category : #accessing }
RSPangoMarkup >> markup: aString [

	markup := String streamContents: [ :stream |
		          | span macrosFree |
		          span := '<span font_family="{1}" font_size="{2}pt" foreground="#{3}">'
			                  format: {
					                  self font familyName.
					                  self font pointSize.
					                  self defaultForegroundColor asHexString }.

		          macrosFree := self convertMacros:
			                        aString fixEmptyLinesForPango.

		          stream
			          << '<markup>';
			          << span;
			          << macrosFree;
			          << '</span>';
			          << '</markup>' ].

	^ self text: markup
]

{ #category : #accessing }
RSPangoMarkup >> text: aString [

	| ll clean_text attributesString chunks counter |
	clean_text := markup.

	attributesString := String empty.

	ll := LibLua uniqueInstance.

	self withPangoAttrListFromString: '' do: [ :emptyAttrListHandler |
		ll withOpenedLibsStateDo: [ :L |
			| parsed attributesSize |
			ll on: L assertLUAOK: [
				ll
					luaL_requiref: L name: 'cairo';
					on: L push: #cairo;
					lua_getfield: L at: -1 name: 'pango_parse_markup';
					on: L push: clean_text;
					on: L push: 0;
					on: L push: emptyAttrListHandler;
					lua_pcall: L nargs: 3 nresults: 4 ].

			parsed := ll on: L at: -4.


			self
				assert: parsed
				description: 'Failed to parse the given Pango markup string.'.

			clean_text := ll on: L at: -3.
			attributesString := ll on: L at: -2.
			attributesSize := ll on: L at: -1.

			self
				assert: attributesSize >= 0
				description: 'Invalid size of attributes list.'.

			self assert: (clean_text lines select: #isEmpty) isEmpty ] ].

	chunks := SortedCollection sortUsing: [ :a :b |
		          a third = b third
			          ifTrue: [
				          a second = b second
					          ifTrue: [ a first < b first ]
					          ifFalse: [ a second < b second ] ]
			          ifFalse: [ a third < b third ] ].

	counter := 1.

	attributesString ifNotEmpty: [
		(Character lf split: attributesString) withIndexDo: [ :attrStr :i |
			| spaceIndex from |
			spaceIndex := attrStr indexOf: Character space.

			from := attrStr copyFrom: 1 to: spaceIndex - 1.

			chunks add: {
					counter.
					i.
					from asInteger.
					attrStr } ] ].

	auxiliaryOrderedLabelLanguageAssociations do: [ :assoc |
		| i label language |
		label := assoc key.
		language := assoc value.

		counter := counter + 1.

		i := clean_text findString: label.

		self
			assert: i > 0
			description: 'Impossible to not find a code label.'.

		language
			populate: chunks
			offset: i + label size + 1
			text: clean_text
			counter: counter ].

	self attributesChunks: (chunks collect: #last).

	^ super text: clean_text
]
