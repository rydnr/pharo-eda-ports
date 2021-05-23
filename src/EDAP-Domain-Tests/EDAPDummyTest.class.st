Class {
	#name : #EDAPDummyTest,
	#superclass : #TestCase,
	#instVars : [
		'a',
		'b'
	],
	#category : #'EDAP-Domain-Tests'
}

{ #category : #tests }
EDAPDummyTest >> testTautology [
	self assert: true
]
