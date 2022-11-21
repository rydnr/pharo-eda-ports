Class {
	#name : #EDAPTopicListener,
	#superclass : #Object,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#category : #'EDAP-Messaging-Topic'
}

{ #category : #reading }
EDAPTopicListener >> onMessageDo: aBlock [
	self subclassResponsibility
]

{ #category : #lifecycle }
EDAPTopicListener >> subscribe [
	self subclassResponsibility
]

{ #category : #lifecycle }
EDAPTopicListener >> unsubscribe [
	self subclassResponsibility
]
