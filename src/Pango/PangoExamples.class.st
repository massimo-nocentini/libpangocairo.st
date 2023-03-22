Class {
	#name : #PangoExamples,
	#superclass : #Object,
	#category : #Pango
}

{ #category : #examples }
PangoExamples class >> example1 [
	<example>
	| fontDescription surface |
	
	fontDescription := PangoFontDescription newFromString: 'Ubuntu Mono 20'.
	surface := AthensCairoSurface width: 500 height: 500.
	surface drawDuring: [ :canvas | | fontLayout |
		fontLayout := PangoLayout newCanvas: canvas.
		fontLayout fontDescription: fontDescription.
		fontLayout markup: '<span foreground="blue" font_family="Ubuntu">
		<b> bold </b>
		<u> is </u>
		<i> nice </i>
	</span>
	<tt> hello </tt>
	 <span font_family="sans" font_stretch="ultracondensed" letter_spacing="500" font_weight="light"> SANS</span><span foreground="#FFCC00"> colored</span>
	'.
	
		canvas updateLayout: fontLayout.

		canvas paintTransform rotateByDegrees: 45.

		canvas showLayout: fontLayout ].

	surface asForm asMorph openInWindow 
		
]

{ #category : #examples }
PangoExamples class >> example2 [

	<example>
	| pango |
	pango := RSPangoText new
		         markup: '<span><tt>'
			         ,
				         (RSAthensRenderer >> #visitPangoText:) inspectionSource
					         textWithStyle asString , '</tt></span>';
		         notedWithPad: Float goldenRatio.

	pango draggable.

	RSCanvas new
		add: pango;
		@ RSCanvasController;
		open
]

{ #category : #'see class side' }
PangoExamples >> seeClassSide [
]
