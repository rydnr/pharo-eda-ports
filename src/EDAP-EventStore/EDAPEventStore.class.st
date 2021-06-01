Class {
	#name : #EDAPEventStore,
	#superclass : #Object,
	#traits : 'EDACPrintOnHelper',
	#classTraits : 'EDACPrintOnHelper classTrait',
	#instVars : [
		'repository'
	],
	#category : #'EDAP-EventStore'
}

{ #category : #persistence }
EDAPEventStore >> doInitialize [
	self repository: self initBackendRepository
]

{ #category : #persistence }
EDAPEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass [
	^ self
		findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass
		whereCriteria: Dictionary new
]

{ #category : #persistence }
EDAPEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereCriteria: aCriteriaDictionary [
	self subclassResponsibility
]

{ #category : #persistence }
EDAPEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereId: aNumber [
	self subclassResponsibility
]

{ #category : #persistence }
EDAPEventStore >> findEventsOfTenant: aTenant ofType: anEventClass [
	^ self
		findEventsOfTenant: aTenant ofAggregate: anEventClass aggregateRootClass
		whereCriteria: {('#instanceOf' -> anEventClass greaseString)} asDictionary
]

{ #category : #persistence }
EDAPEventStore >> findEventsOfTenant: aTenant ofType: anEventClass whereCriteria: aCriteria [
	| criteria |
	criteria := Dictionary newFrom: aCriteria.
	criteria at: '#instanceOf' put: anEventClass greaseString.
	^ self
		findEventsOfTenant: aTenant
		ofAggregate: anEventClass aggregateRootClass
		whereCriteria: criteria
]

{ #category : #persistence }
EDAPEventStore >> flush [
	self repository flush

	
]

{ #category : #persistence }
EDAPEventStore >> initBackendRepository [
	self subclassResponsibility
]

{ #category : #initialization }
EDAPEventStore >> initialize [
	super initialize.
	self doInitialize
]

{ #category : #initialization }
EDAPEventStore >> repository [
	^ repository
]

{ #category : #accessing }
EDAPEventStore >> repository: aRepository [
	repository := aRepository
]

{ #category : #persistence }
EDAPEventStore >> saveEvents: anEventCollection [
	self subclassResponsibility
]
