"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestLibPangoCairo',
	#superclass : 'PackageManifest',
	#category : 'LibPangoCairo-Manifest',
	#package : 'LibPangoCairo',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestLibPangoCairo class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#PangoMarkupMicrodownVisitor #treeSitterLanguageShapesWithFont: #false)) #'2024-07-07T15:09:56.169834+02:00') )
]

{ #category : 'code-critics' }
ManifestLibPangoCairo class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#PangoMarkupMicrodownVisitor #treeSitterLanguageShapesWithFont: #false)) #'2024-07-07T15:10:07.769909+02:00') )
]
