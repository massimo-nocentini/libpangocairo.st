Class {
	#name : #RSPangoMarkup,
	#superclass : #RSPangoWithAttrList,
	#instVars : [
		'markup',
		'attributesString',
		'initialOffset'
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
RSPangoMarkup >> attributesChunks [

	^ attributesString splitOn: Character lf
]

{ #category : #initialization }
RSPangoMarkup >> initialize [

	super initialize.

	initialOffset := 0
]

{ #category : #accessing }
RSPangoMarkup >> text: aString [

	| ll clean_text |
	"Keep a reference to the original markup string."
	markup := aString.

	clean_text := aString fixEmptyLinesForPango.

	Conversions keysAndValuesDo: [ :macro :replacement |
		clean_text := clean_text copyReplaceAll: macro with: replacement ].

	ll := LibLua uniqueInstance.

	ll withOpenedLibsStateDo: [ :L |
		| flag parsed |
		flag := ll
			        luaL_requiref: L name: 'cairo';
			        on: L push: #cairo;
			        lua_getfield: L at: -1 name: 'pango_parse_markup';
			        on: L push: clean_text;
			        on: L push: initialOffset;
			        lua_pcall: L nargs: 2 nresults: 3.

		parsed := ll on: L at: -3.
		clean_text := ll on: L at: -2.
		attributesString := ll on: L at: -1.

		self
			assert: flag = ll LUA_OK
			description: 'Failed to execute `pango_parse_markup` function.'.

		self
			assert: parsed
			description: 'Failed to parse the given Pango markup string.' ].

	^ super text: clean_text
]
