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
			self
				initializeMacOSdefaultFontSize: defaultFontSize
				codeFontSize: codeFontSize ]
		ifFalse: [
			Smalltalk os isLinux
				ifTrue: [
					self
						initializeLinuxDefaultFontSize: defaultFontSize
						codeFontSize: codeFontSize ]
				ifFalse: [
					self
						initializeWinDefaultFontSize: defaultFontSize
						codeFontSize: codeFontSize ] ]
]

{ #category : 'class initialization' }
PangoLogicalFontManager class >> initializeLinuxDefaultFontSize: defaultFontSize codeFontSize: codeFontSize [

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
		                             pointSize: codeFontSize
]

{ #category : 'class initialization' }
PangoLogicalFontManager class >> initializeMacOSdefaultFontSize: defaultFontSize codeFontSize: codeFontSize [

	PangoMathLogicalFont := LogicalFont
		                        familyName: 'Euler Math'
		                        pointSize: defaultFontSize.

	PangoSansLogicalFont := LogicalFont
		                        familyName: 'Lucida Grande'
		                        pointSize: defaultFontSize.

	PangoSerifLogicalFont := LogicalFont
		                         familyName: 'Times New Roman'
		                         pointSize: defaultFontSize.

	PangoMonospaceLogicalFont := LogicalFont
		                             familyName: 'Monaco'
		                             pointSize: codeFontSize
]

{ #category : 'class initialization' }
PangoLogicalFontManager class >> initializeWinDefaultFontSize: defaultFontSize codeFontSize: codeFontSize [

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
		                             pointSize: codeFontSize
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
