Class {
	#name : #EDAPCommandConsumer,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper + EDACErrorHelper',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACErrorHelper classTrait',
	#instVars : [
		'busListener',
		'commandMaterializer',
		'commandDispatcher'
	],
	#classInstVars : [
		'restartOnCommandConsumingErrors'
	],
	#category : #'EDAP-Messaging-Command'
}

{ #category : #'instance creation' }
EDAPCommandConsumer class >> busListener: busListener commandMaterializer: commandMaterializer commandDispatcher: commandDispatcher [
	^ self new
		busListener: busListener;
		commandMaterializer: commandMaterializer;
		commandDispatcher: commandDispatcher;
		yourself
]

{ #category : #logging }
EDAPCommandConsumer class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPCommandConsumer class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPCommandConsumer class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPCommandConsumer class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAPCommandConsumer class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #accessing }
EDAPCommandConsumer class >> restartOnCommandConsumingErrors [
	^ restartOnCommandConsumingErrors
]

{ #category : #accessing }
EDAPCommandConsumer class >> restartOnCommandConsumingErrors: aBoolean [
	restartOnCommandConsumingErrors := aBoolean
]

{ #category : #accessing }
EDAPCommandConsumer >> busListener [
	^ busListener
]

{ #category : #accessing }
EDAPCommandConsumer >> busListener: anObject [
	busListener := anObject
]

{ #category : #lifecycle }
EDAPCommandConsumer >> close [
	self busListener close
]

{ #category : #accessing }
EDAPCommandConsumer >> commandDispatcher [
	^ commandDispatcher
]

{ #category : #accessing }
EDAPCommandConsumer >> commandDispatcher: anObject [
	commandDispatcher := anObject
]

{ #category : #accessing }
EDAPCommandConsumer >> commandMaterializer [
	^ commandMaterializer
]

{ #category : #accessing }
EDAPCommandConsumer >> commandMaterializer: anObject [
	commandMaterializer := anObject
]

{ #category : #reading }
EDAPCommandConsumer >> consumeMessage: aCommandMessageString [
	^ self consumeMessage: aCommandMessageString usingStrategy: EDAECommandConsumingErrorBehavior strategy
]

{ #category : #reading }
EDAPCommandConsumer >> consumeMessage: aCommandMessageString usingStrategy: aStrategy [
	| aCommand |
	aCommand := self commandMaterializer
		materialize: aCommandMessageString.
	^ self commandDispatcher dispatch: aCommand usingStrategy: aStrategy
]

{ #category : #helpers }
EDAPCommandConsumer >> printOn: t1 [
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

{ #category : #lifecycle }
EDAPCommandConsumer >> restart [
	self logWarningMessage: 'Restarting Command Consumer..'.
	[ self stop ]
		ensure: [ self start ]
]

{ #category : #lifecycle }
EDAPCommandConsumer >> start [
	| listenerProcess |
	self logWarningMessage: 'Starting Command Consumer...'.
	self busListener resetClient.
	listenerProcess := self busListener
		subscribe;
		onMessageDo: [ :message | self consumeMessage: message ].
	listenerProcess
		on: Exception - Break
		do: [ :error | 
			self
				manageError: error
				usingErrorStrategy: EDAECommandConsumingErrorBehavior strategy.
			self class restartOnCommandConsumingErrors
				ifTrue: [ self restart ] ].
	listenerProcess resume
]

{ #category : #lifecycle }
EDAPCommandConsumer >> stop [
	[ self busListener forceUnsubscribe.
	self logWarningMessage: 'Stopped Command Consumer.' ]
		on: Error
		do: [ :ex |
			self
				logErrorMessage: 'Error stopping Command Consumer: ' , ex description , '.' ]
]
