Class {
	#name : #EDAPCommandConsumer,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper + EDACErrorHelper + EDACLogging',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACErrorHelper classTrait + EDACLogging classTrait',
	#instVars : [
		'busListener',
		'commandMaterializer',
		'commandDispatcher',
		'edaApplication'
	],
	#category : #'EDAP-Messaging-Command'
}

{ #category : #'instance creation' }
EDAPCommandConsumer class >> busListener: busListener commandMaterializer: commandMaterializer commandDispatcher: commandDispatcher forApp: anEDAApplication [

	^ self new
		  busListener: busListener;
		  commandMaterializer: commandMaterializer;
		  commandDispatcher: commandDispatcher;
		  edaApplication: anEDAApplication;
		  yourself
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
EDAPCommandConsumer >> edaApplication [

	^ edaApplication
]

{ #category : #accessing }
EDAPCommandConsumer >> edaApplication: anObject [

	edaApplication := anObject
]

{ #category : #accessing }
EDAPCommandConsumer >> errorStrategy [

	^ self edaApplication portSettings commandListenerSettings errorStrategy ifNil: [ EDAECommandConsumingErrorBehavior strategy ]
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

{ #category : #accessing }
EDAPCommandConsumer >> restartOnErrors [

	^ self settings restartOnErrors ifNil: [ true ]
]

{ #category : #lifecycle }
EDAPCommandConsumer >> start [

	| listenerProcess |
	self logWarningMessage: 'Starting Command Consumer...'.
	self busListener resetClient.
	listenerProcess := self busListener
		                   subscribe;
		                   onMessageDo: [ :message | 
			                   self consumeMessage: message ].
	listenerProcess
		on: Exception - Break
		do: [ :error | 
			self manageError: error usingErrorStrategy: self errorStrategy.
			self restartOnErrors ifTrue: [ self restart ] ].
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
