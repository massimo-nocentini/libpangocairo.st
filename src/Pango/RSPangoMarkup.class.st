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
RSPangoMarkup >> convertMacros: aString [

	| converted |
	converted := aString.

	Conversions keysAndValuesDo: [ :macro :replacement |
		converted := converted copyReplaceAll: macro with: replacement ].

	^ converted
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

	^ self
		  ffiCall:
			  #( void pango_layout_set_markup #( void #* layoutHandler
			        #, const char #* aString #, -1 ) )
		  module: PangoLibrary
]

{ #category : 'handle' }
RSPangoMarkup >> pangoAttrListString [

	^ String empty
]

{ #category : 'accessing' }
RSPangoMarkup >> text: aString [

	| markupString |
	markupString := String streamContents: [ :stream |
		                | span macrosFree |
		                span := '<span {1} foreground="#{2}">' format: {
				                        self font pangoMarkupSpanTagContent.
				                        self defaultForegroundColor asHexString }.

		                macrosFree := self convertMacros:
			                              aString fixEmptyLinesForPango.

		                stream
			                << '<markup>';
			                << span;
			                << macrosFree;
			                << '</span>';
			                << '</markup>' ].

	^ super text: markupString
]

{ #category : 'accessing' }
RSPangoMarkup >> text_complex: markupString [

	| ll cleanedString attributesString chunks counter |
	cleanedString := markupString.

	attributesString := String empty.

	ll := LibLua uniqueInstance implementationPrimitive.

	self
		withPangoAttrListFromString: String empty
		do: [ :emptyAttrListHandler |
			ll withOpenedLibsStateDo: [ :L |
				| parsed attributesSize |
				ll on: L assertLUAOK: [
					ll
						luaL_requiref: L name: 'cairo';
						on: L push: #cairo;
						lua: L get: -1 field: 'pango_parse_markup';
						on: L push: cleanedString;
						on: L push: 0;
						on: L push: emptyAttrListHandler;
						lua_pcall: L nargs: 3 nresults: 4 ].

				parsed := ll on: L at: -4.


				self
					assert: parsed
					description: 'Failed to parse the given Pango markup string.'.

				cleanedString := ll on: L at: -3.
				attributesString := ll on: L at: -2.
				attributesSize := ll on: L at: -1.

				self
					assert: attributesSize >= 0
					description: 'Invalid size of attributes list.'.

				self assert: (cleanedString lines select: #isEmpty) isEmpty ] ].

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

	self attributesChunks: (chunks collect: #last).

	^ super text: cleanedString
]

{ #category : 'ffi bindings' }
RSPangoMarkup >> withPangoAttrListFromString: aString do: aBlock [

	aBlock value: ExternalAddress null
]
