Class {
	#name : #BaselineOfPharoEDAPorts,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDAPorts
}

{ #category : #baselines }
BaselineOfPharoEDAPorts >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			self includePharoEDACommon: spec.
			self includePharoEDAApi: spec.
			self declarePackagesIn: spec.
			self declareGroupsIn: spec ]
]

{ #category : #meta }
BaselineOfPharoEDAPorts >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAP-Domain' 'EDAP-EventStore');
		group: 'tests'
			with:
			#(#'EDAP-Domain-Tests');
		group: 'default' with: #('core' 'tests')
]

{ #category : #meta }
BaselineOfPharoEDAPorts >> declarePackagesIn: spec [
	spec
		package: #'EDAP-Domain'
			with: [ spec requires: #('PharoEDACommon' 'PharoEDAApi') ];
		package: #'EDAP-Domain-Tests'
			with: [ spec requires: #('EDAP-Domain') ];
		package: #'EDAP-EventStore'
			with: [ spec requires: #('PharoEDACommon' 'PharoEDAApi') ]
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts >> includePharoEDAApi: spec [
	spec
		baseline: 'PharoEDAApi'
		with: [ spec repository: 'github://osoco/pharo-eda-api:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://osoco/pharo-eda-common:main' ].
	^ spec
]
