Class {
	#name : #BaselineOfPango,
	#superclass : #BaselineOf,
	#category : #BaselineOfPango
}

{ #category : #baselines }
BaselineOfPango >> baseline: spec [ 
	<baseline>
	
	spec for: #common do: [ 
		spec package: 'Pango' ]
]
