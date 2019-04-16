package com.watabou.compass.data.layers;

import openfl.geom.Point;

import com.watabou.compass.data.marks.Mark;

class LayerRow extends Layer {

	public var radius   : Float;
	public var offset   : Float;
	public var n        : Int;

	public var mark : Mark;

	public function new( radius:Float, n:Int, offset:Float, mark:Mark ) {
		super();

		this.radius = radius;
		this.offset = offset;
		this.n = n;

		this.mark = mark;
	}

	override private function drawCore( brush:Brush ) {
		for (i in 0...n) {
			var a = Math.PI * (2 * i / n + offset);
			var p = Point.polar( radius, a );
			mark.draw( brush, p, a );
		}
	}
}
