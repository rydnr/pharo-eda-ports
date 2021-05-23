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
			self declarePackagesIn: spec.
			self declareGroupsIn: spec ]
]

{ #category : #meta }
BaselineOfPharoEDAPorts >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAP-Domain');
		group: 'tests'
			with:
			#(#'EDAP-Domain-Tests');
		group: 'default' with: #('core' 'tests')
]

{ #category : #meta }
BaselineOfPharoEDAPorts >> declarePackagesIn: spec [
	spec
		package: #'EDAP-Domain';
		package: #'EDAP-Domain-Tests'
			with: [ spec requires: #('EDAP-Domain') ]
 
]
