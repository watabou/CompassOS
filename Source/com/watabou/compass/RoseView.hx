package com.watabou.compass;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.utils.Assets;

import com.watabou.compass.data.Rose;

class RoseView extends Sprite {

	public static var LABELS = true;

	public var labels : Sprite;

	private var brush : Brush;

	public function new( rose:Rose ) {
		super();

		brush = new Brush( graphics );

		for (layer in rose.layers)
			layer.draw( brush );

		createLabels( rose );
	}

	private function createLabels( rose:Rose ) {
		labels = new Sprite();
		labels.visible = LABELS;
		addChild( labels );

		var color = Brush.DARK;

		var n = createLabel( "N", color );
		var o = n.getLineMetrics( 0 ).descent;
		n.x = -n.width / 2;
		n.y = -rose.n - n.height + 2;

		var s = createLabel( "S", color );
		s.x = -s.width / 2;
		s.y = rose.s - 2;

		var w = createLabel( "W", color );
		w.x = -rose.w - w.width + 2 - o;
		w.y = -w.height / 2;

		var e = createLabel( "E", color );
		e.x = rose.e - 2 + o;
		e.y = -e.height / 2;
	}

	private function createLabel( txt:String, color:UInt ):TextField {
		var tf = new TextField();
		tf.mouseEnabled = false;
		tf.defaultTextFormat = new TextFormat( Assets.getFont( "regular" ).fontName, 72, color );
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = txt;
		labels.addChild( tf );

		return tf;
	}
}
