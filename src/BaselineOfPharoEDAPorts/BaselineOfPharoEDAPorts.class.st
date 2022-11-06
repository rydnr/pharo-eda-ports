"
**Class**

I'm a baseline to load PharoEDA Ports.

**Responsibilities**

Guide Metacello to load PharoEDA-Ports with its dependencies.

**Collaborators**

Metacello
"
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
			self includePharoEDAErrors: spec.
			self declarePackagesIn: spec.
			self declareGroupsIn: spec ]
]

{ #category : #meta }
BaselineOfPharoEDAPorts >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAP-Domain' 'EDAP-EventStore' 'EDAP-Messaging');
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
			with: [ spec requires: #('PharoEDACommon' 'PharoEDAApi') ];
		package: #'EDAP-Messaging'
			with: [ spec requires: #('PharoEDACommon' 'PharoEDAApi' 'PharoEDAErrors') ]
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts >> includePharoEDAApi: spec [
	spec
		baseline: 'PharoEDAApi'
		with: [ spec repository: 'github://rydnr/pharo-eda-api:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://rydnr/pharo-eda-common:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts >> includePharoEDAErrors: spec [
	spec
		baseline: 'PharoEDAErrors'
		with: [ spec repository: 'github://rydnr/pharo-eda-errors:main' ].
	^ spec
]

{ #category : #hooks }
BaselineOfPharoEDAPorts >> postload: loader package: packageSpec [

	| location |
	location := (IceRepository registry detect: [ :each | 
		             each name = 'pharo-eda-ports' ]) location.
	EDAIconProvider addDefaultLocation: location / 'resources' / 'icons'.
	EDACTranslationProvider addDefaultLocation:
		location / 'resources' / 'l10n'
]
