package com.watabou.geom;

import openfl.geom.Point;
import openfl.geom.Vector3D;

class GeomUtils {
	public static function intersectLines( x1:Float, y1:Float, dx1:Float, dy1: Float, x2:Float, y2:Float, dx2:Float, dy2:Float ):Point {
		var d = dx1 * dy2 - dy1 * dx2;
		if (d == 0)
			return null;

		var t2 = (dy1 * (x2 - x1) - dx1 * (y2 - y1)) / d;
		var t1 = Math.abs( dx1 ) > Math.abs( dy1 ) ?//(dx1 != 0) ?
			(x2 - x1 + dx2 * t2) / dx1 :
			(y2 - y1 + dy2 * t2) / dy1;

		return new Point( t1, t2 );
	}

	public static inline function intersectSegments( x1:Float, y1:Float, dx1:Float, dy1: Float, x2:Float, y2:Float, dx2:Float, dy2:Float ):Bool {
		var t = intersectLines( x1, y1, dx1, dy1, x2, y2, dx2, dy2 );
		return (t.x >= 0 && t.x <= 1 && t.y >= 0 && t.y <= 1);
	}

	public static function lerp( p1:Point, p2:Point, ratio=0.5 ):Point {
		var d = p2.subtract( p1 );
		return new Point( p1.x + d.x * ratio, p1.y + d.y * ratio );
	}

	public static inline function scalar( x1:Float, y1:Float, x2:Float, y2:Float )
		return x1 * x2 + y1 * y2;

	public static inline function cross( x1:Float, y1:Float, x2:Float, y2:Float )
		return x1 * y2 - y1 * x2;

	public static function distance2line( x1:Float, y1:Float, dx1:Float, dy1:Float, x0:Float, y0:Float ):Float
		return (dx1 * y0 - dy1 * x0 + (y1 + dy1) * x1 - (x1 + dx1) * y1) / Math.sqrt( dx1 * dx1 + dy1 * dy1 );

	public static function converge( p0:Point, p1:Point, q0:Point, q1:Point ):Bool {

		var dxp = p1.x - p0.x;
		var dyp = p1.y - p0.y;
		var z = (p1.x * p0.y - p1.y * p0.x);

		inline function d2l( q:Point ):Float
			return Math.abs( (dxp * q.y - dyp * q.x - z) );

		return (d2l( q0 ) < 1.e-9 && d2l( q1 ) < 1.e-9);
	}

	public static function pointInsideTriangle( a:Point, b:Point, c:Point, s:Point ):Bool {
		var asX = s.x - a.x;
		var asY = s.y - a.y;
		var bsX = s.x - b.x;
		var bsY = s.y - b.y;

		var s_ab = ((b.x - a.x) * asY - (b.y - a.y) * asX >= 0);

		if ((c.x - a.x) * asY - (c.y - a.y) * asX >= 0 == s_ab) return false;
		if ((c.x - b.x) * bsY - (c.y - b.y) * bsX >= 0 != s_ab) return false;

		return true;
	}

	public static function barycentric( p1:Point, p2:Point, p3:Point, f:Point ):Vector3D {
		var f1 = p1.subtract( f );
		var f2 = p2.subtract( f );
		var f3 = p3.subtract( f );

		var a = cross( p1.x - p2.x, p1.y - p2.y, p1.x - p3.x, p1.y - p3.y );
		var a1 = cross( f2.x, f2.y, f3.x, f3.y );
		var a2 = cross( f3.x, f3.y, f1.x, f1.y );
		var a3 = cross( f1.x, f1.y, f2.x, f2.y );

		return new Vector3D( a1 / a, a2 / a, a3 / a );
	}

	public static function pointInSector( a:Point, b:Point, c:Point, p:Point ):Float {
		var v1 = b.subtract( a );
		var v2 = c.subtract( b );
		var cross = cross( v1.x, v1.y, v2.x, v2.y );

		var sign1 = p.x * v1.y - p.y * v1.x - (a.x * b.y - b.x * a.y);
		if (sign1 * cross > 0)
			return sign1
		else {
			var sign2 = p.x * v2.y - p.y * v2.x - (b.x * c.y - c.x * b.y);
			return p.x * v2.y - p.y * v2.x - (b.x * c.y - c.x * b.y);
		}
	}
}