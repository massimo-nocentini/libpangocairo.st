Class {
	#name : 'BaselineOfPango',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPango',
	#package : 'BaselineOfPango'
}

{ #category : 'baselines' }
BaselineOfPango >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'LibLuast'
			with: [ spec repository: 'github://massimo-nocentini/liblua.st' ].

		spec package: 'Pango' ]
]
