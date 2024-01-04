Class {
	#name : 'BaselineOfLibPangoCairo',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfLibPangoCairo',
	#package : 'BaselineOfLibPangoCairo'
}

{ #category : 'baselines' }
BaselineOfLibPangoCairo >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec baseline: 'VMPluginsPrimitives' with: [
			spec repository:
				'github://massimo-nocentini/vm-plugins-primitives.st' ].

		spec
			baseline: 'LibTreeSitter'
			with: [ spec repository: 'github://massimo-nocentini/libtreesitter.st' ].

		spec
			package: 'LibPangoCairo';
			package: 'LibPangoCairo-Tests' ]
]
