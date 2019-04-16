package com.watabou.compass.data.marks;

import openfl.geom.Point;

import com.watabou.geom.polygons.PolyTransform;

using com.watabou.utils.GraphicsExtender;

class MarkPoly extends Mark {

	private var proto : Array<Point>;

	private var isLinework = false;

	override public function draw( brush:Brush, p:Point, a:Float ) {
		var p = PolyTransform.translate( PolyTransform.rotate( proto, a ), p.x, p.y );

		if (isLinework)
			brush.lineFill()
		else
			brush.paint( primary );
		brush.g.drawPolygon( p );
		brush.end();
	}
}
