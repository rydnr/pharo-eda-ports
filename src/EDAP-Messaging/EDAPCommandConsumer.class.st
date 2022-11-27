Class {
	#name : #EDAPCommandConsumer,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper + EDACErrorHelper + EDACLogging',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACErrorHelper classTrait + EDACLogging classTrait',
	#instVars : [
		'busListener',
		'commandMaterializer',
		'commandDispatcher',
		'errorStrategy'
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

{ #category : #'instance creation' }
EDAPCommandConsumer class >> busListener: busListener commandMaterializer: commandMaterializer commandDispatcher: commandDispatcher andErrorStrategy: errorStrategy [

	^ self new
		  busListener: busListener;
		  commandMaterializer: commandMaterializer;
		  commandDispatcher: commandDispatcher;
		errorStrategy: errorStrategy;
		  yourself
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

	^ self
		  consumeMessage: aCommandMessageString
		  usingStrategy: self errorStrategy
]

{ #category : #reading }
EDAPCommandConsumer >> consumeMessage: aCommandMessageString usingStrategy: aStrategy [
	| aCommand |
	aCommand := self commandMaterializer
		materialize: aCommandMessageString.
	^ self commandDispatcher dispatch: aCommand usingStrategy: aStrategy
]

{ #category : #accessing }
EDAPCommandConsumer >> errorStrategy [

	^ errorStrategy ifNil: [ EDAECommandConsumingErrorBehavior strategy ]
]

{ #category : #accessing }
EDAPCommandConsumer >> errorStrategy: anObject [

	errorStrategy := anObject
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
