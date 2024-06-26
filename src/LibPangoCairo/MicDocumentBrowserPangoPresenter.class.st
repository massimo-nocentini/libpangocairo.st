Class {
	#name : 'MicDocumentBrowserPangoPresenter',
	#superclass : 'MicDocumentBrowserPresenter',
	#category : 'LibPangoCairo-Microdown',
	#package : 'LibPangoCairo',
	#tag : 'Microdown'
}

{ #category : 'opening' }
MicDocumentBrowserPangoPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Documentation Browser - Roassal')
		parent: #Help;
		order: 0;
		action: [ self open ];
		iconName: #smallHelp;
		help: 'Explore a list of available documentation usign Roassal.'
]

{ #category : 'navigation' }
MicDocumentBrowserPangoPresenter >> documentSelected: document [
	"document is newly selected, and should be rendered. If source is showing, set it as well"

	documentModel save.
	documentModel resourceReference: document.
	documentModel resourceReference ifNil: [ ^ self ].

	spRendering refresh.

	self updateSourcePresenter.
	self owner title:
		(self displayStringOf: documentModel resourceReference)
]

{ #category : 'initialization' }
MicDocumentBrowserPangoPresenter >> initializePresenters [

	super initializePresenters.

	spRendering := self newRoassal
		               script: [ :aCanvas |
			               documentModel document ifNotNil: [ :micElement |
					               | shape |
					               shape := PangoMarkupMicrodownVisitor new
						                        visit: micElement;
						                        asRSPangoShapeUsingFont:
							                        PangoLogicalFontManager pangoSerif.

					               aCanvas
						               add: shape;
						               @ RSCanvasController;
						               signalUpdate ] ];
		               yourself
]
