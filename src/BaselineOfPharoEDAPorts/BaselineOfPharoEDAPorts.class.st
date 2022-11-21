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

{ #category : #meta }
BaselineOfPharoEDAPorts class >> declareGroupsIn: spec [

	spec
		group: 'core' with: #( 'EDAP-EventStore' 'EDAP-Messaging' );
		group: 'default'
		with: #( 'core' )
]

{ #category : #meta }
BaselineOfPharoEDAPorts class >> declarePackagesIn: spec [

	spec
		package: #'EDAP-EventStore'
		with: [ spec requires: #( 'PharoEDACommon' 'PharoEDAApi' ) ];
		package: #'EDAP-Messaging'
		with: [ 
			spec requires: #( 'PharoEDACommon' 'PharoEDAApi' 'PharoEDAErrors' ) ]
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts class >> includePharoEDAApi: spec [
	spec
		baseline: 'PharoEDAApi'
		with: [ spec repository: 'github://rydnr/pharo-eda-api:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts class >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://rydnr/pharo-eda-common:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAPorts class >> includePharoEDAErrors: spec [
	spec
		baseline: 'PharoEDAErrors'
		with: [ spec repository: 'github://rydnr/pharo-eda-errors:main' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDAPorts >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec postLoadDoIt: #postload:package:.
		self class includePharoEDACommon: spec;
		 includePharoEDAApi: spec;
		 includePharoEDAErrors: spec;
		 declarePackagesIn: spec;
		 declareGroupsIn: spec ]
]

{ #category : #hooks }
BaselineOfPharoEDAPorts >> postload: loader package: packageSpec [

	| location |
	location := (IceRepository registry detect: [ :each | 
		             each name = 'pharo-eda-ports' ]) location.
	EDACIconProvider addDefaultLocation: location / 'resources' / 'icons'.
	EDACTranslationProvider addDefaultLocation:
		location / 'resources' / 'l10n'
]
