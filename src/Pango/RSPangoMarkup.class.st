Class {
	#name : #RSPangoMarkup,
	#superclass : #RSPangoText,
	#instVars : [
		'markup'
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
RSPangoMarkup >> markup: aString [

	| ll clean_text attributesString chunks |
	"Keep a reference to the original markup string."
	markup := aString.

	attributesString := String empty.
	clean_text := aString fixEmptyLinesForPango.

	Conversions keysAndValuesDo: [ :macro :replacement |
		clean_text := clean_text copyReplaceAll: macro with: replacement ].

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
			clean_text := ll on: L at: -3.
			attributesString := ll on: L at: -2.
			attributesSize := ll on: L at: -1.

			self
				assert: parsed
				description: 'Failed to parse the given Pango markup string.'.

			self
				assert: attributesSize >= 0
				description: 'Invalid size of attributes list.' ] ].

	chunks := OrderedCollection new.

	chunks addAll: (String lf split: attributesString).

	self attributesChunks do: [ :assoc |
		| i label language |
		label := 'code:' , assoc key.
		language := assoc value.

		i := clean_text findString: label.

		self
			assert: i > 0
			description: 'Impossible to not find a code label.'.

		language populate: chunks offset: i + label size - 1 text: clean_text ].


	self attributesChunks: chunks.

	^ self text: clean_text
]
