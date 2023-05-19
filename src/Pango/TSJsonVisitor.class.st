Class {
	#name : #TSJsonVisitor,
	#superclass : #Object,
	#category : #Pango
}

{ #category : #'as yet unclassified' }
TSJsonVisitor >> liblua: ll on: LL [

	| entered id type name isNamed start end |
	entered := ll on: LL at: 1.
	id := ll on: LL at: 2.
	type := ll on: LL at: 3.
	name := ll on: LL at: 4.
	isNamed := ll on: LL at: 5.
	start := ll on: LL at: 6.
	end := ll on: LL at: 7.

	^ 0
]
