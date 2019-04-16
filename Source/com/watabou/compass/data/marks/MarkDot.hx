package com.watabou.compass.data.marks;

import openfl.geom.Point;

class MarkDot extends Mark {

	public function new() {}

	override public function draw( brush:Brush, p:Point, a:Float ) {
		brush.lineFill();
		brush.g.drawCircle( p.x, p.y, Brush.STROKE );
		brush.end();
	}
}
