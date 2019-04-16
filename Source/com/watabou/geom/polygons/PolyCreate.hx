package com.watabou.geom.polygons;

import openfl.geom.Point;

class PolyCreate {

	public static function rect( w:Float, h:Float ):Array<Point> {
		var w2 = w / 2;
		var h2 = h / 2;
		return [new Point( -w2, -h2 ), new Point( w2, -h2 ), new Point( w2, h2 ), new Point( -w2, h2 )];
	}

	public static function regular( n:Int, len:Float ):Array<Point> {
		return [for (i in 0...n) Point.polar( len, Math.PI * 2 * i / n )];
	}
}