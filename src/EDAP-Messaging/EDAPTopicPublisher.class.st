Class {
	#name : #EDAPTopicPublisher,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper',
	#classTraits : 'EDACPrintOnHelper classTrait',
	#instVars : [
		'config'
	],
	#category : #'EDAP-Messaging-Topic'
}

{ #category : #lifecycle }
EDAPTopicPublisher >> close [
	self client close
]

{ #category : #accessing }
EDAPTopicPublisher >> config [

	^ config
]

{ #category : #accessing }
EDAPTopicPublisher >> config: anObject [

	config := anObject
]

{ #category : #writing }
EDAPTopicPublisher >> publishMessage: aMessage [
	self subclassResponsibility
]

{ #category : #writing }
EDAPTopicPublisher >> publishMessage: aMessage inTransaction: transactionId [
	self subclassResponsibility
]

{ #category : #writing }
EDAPTopicPublisher >> publishMessage: aMessage withRoutingKey: aRoutingKeyString [
	self subclassResponsibility
]

{ #category : #writing }
EDAPTopicPublisher >> publishMessagesAtomically: messages [
	self subclassResponsibility
]
