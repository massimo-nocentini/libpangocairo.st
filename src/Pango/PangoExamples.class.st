Class {
	#name : 'PangoExamples',
	#superclass : 'Object',
	#category : 'Pango',
	#package : 'Pango'
}

{ #category : 'examples' }
PangoExamples class >> example1 [

	<example>
	|  surface |
	
	surface := AthensCairoSurface width: 500 height: 500.

	surface drawDuring: [ :canvas |
		| fontLayout |
		fontLayout := PangoLayout newCanvas: canvas.
		fontLayout markup: '<span foreground="blue" font_family="Lucida Grande" font_size="40pt">
		<b> bold </b>
		<u> is </u>
		<i> nice </i>
	</span>
	<tt> hello </tt>
	 <span font_family="sans" font_stretch="ultracondensed" letter_spacing="500" font_weight="light"> SANS</span><span foreground="#FFCC00"> colored<sub>12</sub></span>
	'.

		canvas updateLayout: fontLayout.
		canvas showLayout: fontLayout ].

	surface asForm asMorph openInWindow
]

{ #category : 'examples' }
PangoExamples class >> example2 [

	<example>
	| pango canvas |
	pango := RSPangoMarkup new
		         markup:
			         '<span><tt>' , Object class comment , '</tt></span>';
		         notedWithPad: Float goldenRatio.

	pango draggable.

	canvas := RSCanvas new
		          add: pango;
		          add: (RSLabel new
				           text: 'hello';
				           draggable;
				           yourself);
		          @ RSCanvasController;
		          yourself.

	canvas svgCairoExporter
		zoomToShapes;
		export.

	canvas open
]

{ #category : 'examples' }
PangoExamples class >> example3 [

	<example>
	| pango |
	pango := RSPangoMarkup new
		         markup:
			         '<span foreground="blue" font_family="Cantarell" font_size="12pt"><b> bold </b>
		<u> is </u>
		<i> nice </i>
	</span>
	<tt> hello </tt>
	 <span font_family="sans" font_stretch="ultracondensed" letter_spacing="500" font_weight="light"> SANS</span><span foreground="#FFCC00"> colored</span>';
		         notedWithPad: Float goldenRatio.


	RSGroup new
		add: pango;
		inspect
]

{ #category : 'examples' }
PangoExamples class >> example4 [

	<example>
	| pango |
	pango := RSPangoMarkup new
		         markup:
			         '<span font_family="Cantarell" font_size="12pt">'
			         , 'Hello


world' , '</span>';
		         boxedWithPad: Float goldenRatio * 0.

	RSGroup new
		add: pango;
		add: (RSLabel new
				 text: 'Hello world';
				 fontSize: 12;
				 yourself);
		add: (RSPangoMarkup new boxedWithPad: 0);
		add: (RSPangoMarkup new
				 markup:
					 '<span font_family="Cantarell" font_size="32pt" foreground="red">&#169;</span>';
				 yourself);
		inspect
]

{ #category : 'examples' }
PangoExamples class >> example5 [

	<example>
	| pango |
	pango := RSPangoMarkup new
		         markup:
			         '<span foreground="blue" font_family="Cantarell" font_size="12pt" font_features="dlig=1, -kern, afrc on">'
			         , Object class comment , '</span>';
		         boxedWithPad: Float goldenRatio.


	RSGroup new
		add: pango;
		add: (RSPangoMarkup new
				 markup: '<span color="green">' , Object class comment , '</span>';
				 yourself);
		inspect
]

{ #category : 'examples' }
PangoExamples class >> example6 [

	<example>
	| pango |
	pango := RSPangoMarkup new
		         markup:
			         '<span foreground="blue" font_family="Cantarell" font_size="12pt" font_features="dlig=1, -kern, afrc on"><tt>'
			         ,
				         (PangoLayout >> #pixelSize) inspectionSource
					         textWithStyle asString , '</tt></span>';
		         boxedWithPad: Float goldenRatio.


	RSGroup new
		add: pango;
		inspect
]

{ #category : 'see class side' }
PangoExamples >> seeClassSide [
]
