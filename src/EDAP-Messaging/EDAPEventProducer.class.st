Class {
	#name : #EDAPEventProducer,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper',
	#classTraits : 'EDACPrintOnHelper classTrait',
	#instVars : [
		'serializer',
		'publisher',
		'announcer'
	],
	#category : #'EDAP-Messaging-Event'
}

{ #category : #'instance creation' }
EDAPEventProducer class >> publisher: publisher serializer: serializer announcer: anAnnouncer [
	^ self new
		publisher: publisher;
		serializer: serializer;
		announcer: anAnnouncer;
		yourself
]

{ #category : #helpers }
EDAPEventProducer class >> routingKey: anEvent [
	^ anEvent routingKey
]

{ #category : #accessing }
EDAPEventProducer >> announcer [
	^ announcer
]

{ #category : #accessing }
EDAPEventProducer >> announcer: anObject [
	announcer := anObject
]

{ #category : #lifecycle }
EDAPEventProducer >> close [
	self publisher close
]

{ #category : #helpers }
EDAPEventProducer >> printOn: t1 [
	| t2 |
	t2 := ''.
	self class allInstVarNames
		do: [ :t4 | 
			t2 isEmpty
				ifTrue: [ t2 := '{ ' ]
				ifFalse: [ t2 := t2 , ', ' ].
			t2 := t2 , '"' , t4 , '": "' , (self instVarNamed: t4) asString , '"' ].
	t2 := t2 , ' }'.
	t1 nextPutAll: t2.
	^ self
]

{ #category : #accessing }
EDAPEventProducer >> produceEvent: anEvent [
	| message routingKey |
	message := self serializer serialize: anEvent.
	routingKey := self class routingKey: anEvent.
	routingKey
		ifNotNil: [ :arg | self publisher publishMessage: message withRoutingKey: routingKey ]
		ifNil: [ self publisher publishMessage: message ].
	(anEvent class inheritsFrom: Announcement)
		ifTrue: [ self announcer announce: anEvent ]
]

{ #category : #accessing }
EDAPEventProducer >> produceEvents: anEventCollection [
	anEventCollection ifNotNil: [ anEventCollection do: [ :event | self produceEvent: event ]]
]

{ #category : #accessing }
EDAPEventProducer >> publisher [
	^ publisher
]

{ #category : #accessing }
EDAPEventProducer >> publisher: anObject [
	publisher := anObject
]

{ #category : #accessing }
EDAPEventProducer >> serializer [
	^ serializer
]

{ #category : #accessing }
EDAPEventProducer >> serializer: anObject [
	serializer := anObject
]
