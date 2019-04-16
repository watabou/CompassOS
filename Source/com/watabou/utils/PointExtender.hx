package com.watabou.utils;

import openfl.geom.Point;

import com.watabou.geom.GeomUtils;

class PointExtender {
	public static function set( p:Point, q:Point ) {
		p.x = q.x;
		p.y = q.y;
	}

	public static inline function scale( p:Point, f:Float ):Point
		return new Point( p.x * f, p.y * f );

	public static inline function norm( p:Point, length:Float=1 ):Point {
		p = p.clone();
		p.normalize( length );
		return p;
	}

	public static function addEq( p:Point, q:Point ) {
		p.x += q.x;
		p.y += q.y;
	}

	public static function subEq( p:Point, q:Point ) {
		p.x -= q.x;
		p.y -= q.y;
	}

	public static function scaleEq( p:Point, f:Float ) {
		p.x *= f;
		p.y *= f;
	}

	public static inline function atan( p:Point ):Float
		return Math.atan2( p.y, p.x );

	public static inline function dot( p1:Point, p2:Point ):Float
		return p1.x * p2.x + p1.y * p2.y;

	public static inline function rotate90( p:Point ):Point
		return new Point( -p.y, p.x );

	public static inline function rotate( p:Point, a:Float ):Point {
		var cosB = Math.cos( a );
		var sinB = Math.sin( a );
		return new Point(
			p.x * cosB - p.y * sinB,
			p.y * cosB + p.x * sinB );
	}

	public static inline function scalar( p1:Point, p2:Point ):Float
		return GeomUtils.scalar( p1.x, p1.y, p2.x, p2.y );

	public static inline function cross( p1:Point, p2:Point ):Float
		return GeomUtils.cross( p1.x, p1.y, p2.x, p2.y );

	public static function project( basis:Point, v:Point ):Float {
		var len = basis.length;
		return scalar( basis, v ) / (len * len);
	}
}