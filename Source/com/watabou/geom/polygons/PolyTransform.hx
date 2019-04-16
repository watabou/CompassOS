package com.watabou.geom.polygons;

import openfl.geom.Point;

import com.watabou.geom.polygons.PolyCore.Polygon;

class PolyTransform {
	public static function translate( poly:Polygon, dx:Float, dy:Float ):Polygon {
		return [for (v in poly) new Point( v.x + dx, v.y + dy )];
	}

	public static function add( poly:Polygon, p:Point ):Polygon {
		return translate( poly, p.x, p.y );
	}

	public static function asTranslate( poly:Polygon, dx:Float, dy:Float ) {
		for (v in poly) {
			v.x += dx;
			v.y += dy;
		}
	}

	public static function asAdd( poly:Polygon, p:Point ) {
		asTranslate( poly, p.x, p.y );
	}

	public static function scale( poly:Polygon, sx:Float, sy:Float ):Polygon {
		return [for (v in poly) new Point( v.x * sx, v.y * sy )];
	}

	public static function asScale( poly:Polygon, sx:Float, sy:Float ) {
		for (v in poly) {
			v.x *= sx;
			v.y *= sy;
		}
	}

	public static function rotateYX( poly:Polygon, sin:Float, cos:Float ):Polygon {
		return [for (v in poly) new Point(
			v.x * cos - v.y * sin,
			v.y * cos + v.x * sin
		)];
	}

	public static function rotate( poly:Polygon, angle:Float ):Polygon {
		var sin = Math.sin( angle );
		var cos = Math.cos( angle );
		return [for (v in poly) new Point(
			v.x * cos - v.y * sin,
			v.y * cos + v.x * sin
		)];
	}
}
