Class {
	#name : 'PangoLogicalFontManager',
	#superclass : 'Object',
	#classVars : [
		'PangoMathLogicalFont',
		'PangoMonospaceLogicalFont',
		'PangoSansLogicalFont',
		'PangoSerifLogicalFont'
	],
	#category : 'LibPangoCairo-Font',
	#package : 'LibPangoCairo',
	#tag : 'Font'
}

{ #category : 'class initialization' }
PangoLogicalFontManager class >> initialize [

	| codeFontSize defaultFontSize |
	codeFontSize := StandardFonts codeFont pointSize.
	defaultFontSize := StandardFonts defaultFont pointSize.

	Smalltalk os isMacOS
		ifTrue: [
			PangoMathLogicalFont := LogicalFont
				                        familyName: 'Euler Math'
				                        pointSize: defaultFontSize.

			PangoSansLogicalFont := LogicalFont
				                        familyName: 'Helvetica Neue'
				                        pointSize: defaultFontSize.

			PangoSerifLogicalFont := LogicalFont
				                         familyName: 'Lucide Grande'
				                         pointSize: defaultFontSize.

			PangoMonospaceLogicalFont := LogicalFont
				                             familyName: 'Menlo'
				                             pointSize: codeFontSize ]
		ifFalse: [
			Smalltalk os isLinux
				ifTrue: [
					PangoMathLogicalFont := LogicalFont
						                        familyName: 'Euler Math'
						                        pointSize: defaultFontSize.

					PangoSansLogicalFont := LogicalFont
						                        familyName: 'Source Sans Pro'
						                        pointSize: defaultFontSize.

					PangoSerifLogicalFont := LogicalFont
						                         familyName: 'Source Serif Pro'
						                         pointSize: defaultFontSize.

					PangoMonospaceLogicalFont := LogicalFont
						                             familyName: 'Source Code Pro'
						                             pointSize: codeFontSize ]
				ifFalse: [
					PangoMathLogicalFont := LogicalFont
						                        familyName: 'Euler Math'
						                        pointSize: defaultFontSize.

					PangoSansLogicalFont := LogicalFont
						                        familyName: 'Source Sans Pro'
						                        pointSize: defaultFontSize.

					PangoSerifLogicalFont := LogicalFont
						                         familyName: 'Source Serif Pro'
						                         pointSize: defaultFontSize.

					PangoMonospaceLogicalFont := LogicalFont
						                             familyName: 'Consolas'
						                             pointSize: codeFontSize ] ]
]

{ #category : 'accessing' }
PangoLogicalFontManager class >> pangoMath [

	^ PangoMathLogicalFont
]

{ #category : 'accessing' }
PangoLogicalFontManager class >> pangoMonospace [

	^ PangoMonospaceLogicalFont
]

{ #category : 'accessing' }
PangoLogicalFontManager class >> pangoSans [

	^ PangoSansLogicalFont
]

{ #category : 'accessing' }
PangoLogicalFontManager class >> pangoSerif [

	^ PangoSerifLogicalFont
]
