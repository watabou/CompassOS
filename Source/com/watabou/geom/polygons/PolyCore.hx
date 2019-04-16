package com.watabou.geom.polygons;

import openfl.geom.Point;

using com.watabou.utils.PointExtender;

typedef Polygon = Array<Point>;
typedef PolyPolygon = Array<Polygon>;

class PolyCore {
	public static function area( poly:Polygon ):Float {

		var size = poly.length;

		var v1 = poly[size - 1];
		var v2 = poly[0];

		var s = v1.x * v2.y - v2.x * v1.y;

		for (i in 1...size) {

			v1 = v2;
			v2 = poly[i];

			s += (v1.x * v2.y - v2.x * v1.y);
		}

		return s * 0.5;
	}

	public static function perimeter( poly:Polygon ):Float {

		var size = poly.length;

		var v1 = poly[size - 1];
		var v2 = poly[0];

		var p = Point.distance( v1, v2 );

		for (i in 1...size) {

			v1 = v2;
			v2 = poly[i];

			p = Point.distance( v1, v2 );
		}

		return p;
	}

	public static function center( poly:Polygon ):Point {

		var size = poly.length;

		var c = poly[0].clone();
		for (i in 1...size)
			c.addEq( poly[i] );
		c.scaleEq( 1 / size );

		return c;
	}

	public static function centroid( poly:Polygon ):Point {
		var x = 0.0;
		var y = 0.0;
		var a = 0.0;

		var v1 = poly[poly.length - 1];
		for (i in 0...poly.length) {
			var v0 = v1; v1 = poly[i];
			var f = GeomUtils.cross( v0.x, v0.y, v1.x, v1.y );
			a += f;
			x += (v0.x + v1.x) * f;
			y += (v0.y + v1.y) * f;
		}

		var s6 = 1 / (3 * a);
		return new Point( s6 * x, s6 * y );
	}
}
