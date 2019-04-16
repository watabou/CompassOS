package com.watabou.compass.data.marks;

import openfl.geom.Point;

import com.watabou.geom.polygons.PolyCreate;
import com.watabou.geom.polygons.PolyTransform;
import com.watabou.utils.Random;

import com.watabou.compass.data.layers.LayerRow;

using com.watabou.utils.GraphicsExtender;
using com.watabou.utils.PointExtender;

class MarkRay extends Mark {

	private var proto : Array<Point>;

	public function new() {
		proto = PolyCreate.rect( 1, Brush.STROKE );
		proto = PolyTransform.translate( proto, 0.5, 0 );
	}

	override public function draw( brush:Brush, p:Point, a:Float ) {
		brush.lineFill();
		var poly = PolyTransform.scale( proto, p.length, 1 );
		poly = PolyTransform.rotate( poly, p.atan() );
		brush.g.drawPolygon( poly );
		brush.end();
	}

	public static function rays( r:Float ):LayerRow {
		return new LayerRow( r, 16, (Random.bool() ? 1/16 : 0), new MarkRay() );
	}
}
