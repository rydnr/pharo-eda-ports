Class {
	#name : #EDAPTopicListener,
	#superclass : #Object,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#category : #'EDAP-Messaging'
}

{ #category : #logging }
EDAPTopicListener class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPTopicListener class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPTopicListener class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPTopicListener class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPTopicListener class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

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
