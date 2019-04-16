package com.watabou.compass.data.layers;

class LayerRing extends Layer {

	public var radius1 : Float;
	public var radius2 : Float;
	public var primary : Bool = true;

	public function new( radius1:Float, radius2:Float ) {
		super();
		this.radius1 = radius1;
		this.radius2 = radius2;
	}

	override private function drawCore( brush:Brush ) {
		if (radius1 == radius2) {
			brush.lineFill();
			brush.g.drawCircle( 0, 0, radius1 + Brush.STROKE / 2 );
			brush.g.drawCircle( 0, 0, radius1 - Brush.STROKE / 2 );
		} else {
			brush.paint( primary );
			brush.g.drawCircle( 0, 0, radius1 );
			if (radius2 > 0)
				brush.g.drawCircle( 0, 0, radius2 );
		}

		brush.end();
	}

	public static function circle( r:Float ):LayerRing {
		return new LayerRing( r, r );
	}

	public static function disk( r:Float ):LayerRing {
		return new LayerRing( r, 0 );
	}
}
