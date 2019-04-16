package com.watabou.utils;

import openfl.geom.Point;
import openfl.display.Graphics;

import com.watabou.geom.GeomUtils;
import com.watabou.geom.polygons.PolyCore.Polygon;

using com.watabou.utils.ArrayExtender;
using com.watabou.utils.PointExtender;

class GraphicsExtender {

	public static function drawPolygon( g:Graphics, p:Array<Point> ) {
		var last = p.last();
		g.moveTo( last.x, last.y );
		for (ver in p) {
			g.lineTo( ver.x, ver.y );
		}
	}

	public static function drawPolyline( g:Graphics, p:Array<Point> ) {
		g.moveTo( p[0].x, p[0].y );
		for (i in 1...p.length) {
			g.lineTo( p[i].x, p[i].y );
		}
	}

	public static function drawSmoothPolygon( g:Graphics, p:Array<Point> ) {
		var n = p.length;
		if (n < 3)
			return;

		var p1 = p[n - 3];
		var p2 = p[n - 2];
		var p3 = p[n - 1];
		var t2 = p3.subtract( p1 );
		g.moveTo( p2.x, p2.y );

		for (i in 0...n) {
			var p0 = p1; p1 = p2; p2 = p3; p3 = p[i];

			var t1 = t2; t2 = p3.subtract( p1 );

			var l1 = t1.length;
			var l2 = t2.length;
			var l = p2.subtract( p1 ).length / (l1 + l2) * 0.5;

			var c1 = p1.add( t1.norm( l1 * l ) );
			var c2 = p2.subtract( t2.norm( l2 * l ) );

			g.cubicCurveTo( c1.x, c1.y, c2.x, c2.y, p2.x, p2.y );
		}
	}

	public static function drawSmoothPolyline( g:Graphics, p:Array<Point>, smoothness=1.0 ) {
		var p1 = p[0];
		var p2 = p[1];
		var p3 = p[2];
		var t2 = p3.subtract( p1 );
		g.moveTo( p1.x, p1.y );

		var f = smoothness * 0.333;
		var f2 = smoothness * 0.666;

		var c = p2.subtract( t2.norm( p2.subtract( p1 ).length * f ) );
		g.cubicCurveTo( c.x, c.y, c.x, c.y, p2.x, p2.y );

		for (i in 3...p.length) {
			p1 = p2; p2 = p3; p3 = p[i];

			var t1 = t2; t2 = p3.subtract( p1 );

			var l1 = t1.length;
			var l2 = t2.length;
			var l = p2.subtract( p1 ).length / (l1 + l2) * f2;

			var c1 = p1.add( t1.norm( l1 * l ) );
			var c2 = p2.subtract( t2.norm( l2 * l ) );

			g.cubicCurveTo( c1.x, c1.y, c2.x, c2.y, p2.x, p2.y );
		}

		var c = p2.add( t2.norm( p3.subtract( p2 ).length * f ) );
		g.cubicCurveTo( c.x, c.y, c.x, c.y, p3.x, p3.y );
		g.moveTo( p3.x, p3.y ); // Otherwise glitches happen
	}

	public static function drawSmoothPolylineEx( g:Graphics, p:Array<Point>, smooth:Array<Bool> ) {
		if (p.length < 3) {
			drawPolyline( g, p );
			return;
		}

		var p1 = p[0];
		var p2 = p[1];
		var p3 = p[2];
		var t2:Point;
		g.moveTo( p1.x, p1.y );

		if (smooth[0]) {
			t2 = p3.subtract( smooth[1] ? p1 : p2 );
			var c = p2.subtract( t2.norm( p2.subtract( p1 ).length * 0.333 ) );
			g.cubicCurveTo( c.x, c.y, c.x, c.y, p2.x, p2.y );
		} else {
			t2 = p2.subtract( p1 );
			g.lineTo( p2.x, p2.y );
		}

		for (i in 3...p.length) {
			p1 = p2; p2 = p3; p3 = p[i];

			if (smooth[i-2]) {
				var t1 = t2; t2 = p3.subtract( smooth[1] ? p1 : p2 );

				var l1 = t1.length;
				var l2 = t2.length;
				var l = p2.subtract( p1 ).length / (l1 + l2) * 0.666;

				var c1 = p1.add( t1.norm( l1 * l ) );
				var c2 = p2.subtract( t2.norm( l2 * l ) );

				g.cubicCurveTo( c1.x, c1.y, c2.x, c2.y, p2.x, p2.y );
			} else {
				t2 = p2.subtract( p1 );

				g.lineTo( p2.x, p2.y );
			}
		}

		if (smooth[p.length-2]) {
			var c = p2.add( t2.norm( p3.subtract( p2 ).length * 0.333 ) );
			g.cubicCurveTo( c.x, c.y, c.x, c.y, p3.x, p3.y );
			g.moveTo( p3.x, p3.y ); // Otherwise glitches happen
		} else
			g.lineTo( p3.x, p3.y );
	}

	public static inline function moveToPoint( g:Graphics, p:Point )
		g.moveTo( p.x, p.y );

	public static inline function lineToPoint( g:Graphics, p:Point )
		g.lineTo( p.x, p.y );

	public static function dashedLine( g:Graphics, p1:Point, p2:Point, pattern:Array<Float> ) {
		var down = true;
		var pos = 0;

		moveToPoint( g, p1 );

		while (true) {
			var dist = Point.distance( p1, p2 );
			var dash = pattern[pos];
			if (dist < dash) {
				if (down)
					lineToPoint( g, p2 );
				break;
			}

			p1 = GeomUtils.lerp( p1, p2, dash / dist);
			if (down)
				lineToPoint( g, p1 )
			else
				moveToPoint( g, p1 );

			if (++pos >= pattern.length) pos = 0;
			down = !down;
		}
	}

	public static function dashedPolyline( g:Graphics, poly:Polygon, pattern:Array<Float> ) {
		if (poly.length < 2)
			return;

		var down = true;

		var patIndex = 0;
		var patPos = 0.0;
		var dash = pattern[0];

		var segIndex = 0;
		var p1 = poly[0];
		var p2 = poly[1];

		moveToPoint( g, p1 );

		while (true) {
			var dist = Point.distance( p1, p2 );
			if (patPos + dist < dash) {
				if (down)
					lineToPoint( g, p2 );

				if (++segIndex >= poly.length) break;
				p1 = p2;
				p2 = poly[segIndex];

				patPos += dist;

			} else {
				p1 = GeomUtils.lerp( p1, p2, (dash - patPos) / dist);
				if (down)
					lineToPoint( g, p1 )
				else
					moveToPoint( g, p1 );

				if (++patIndex >= pattern.length) patIndex = 0;
				dash = pattern[patIndex];
				patPos = 0.0;

				down = !down;
			}
		}
	}

	public static function drawArc( g:Graphics, x:Float, y:Float, r:Float, start:Float, end:Float, moveTo=true ) {
		var n = Math.ceil( (end - start) / (Math.PI / 4) );
		if (n < 2) n = 2;
		var step = (end - start) / n;

		function subArc( a0:Float, a1:Float ) {
			var da2 = (a1 - a0) / 2;
			var r1 = r / Math.cos( da2 );
			var cx = x + Math.cos( a0 + da2 ) * r1;
			var cy = y + Math.sin( a0 + da2 ) * r1;
			g.curveTo( cx, cy, x + Math.cos( a1 ) * r, y + Math.sin( a1 ) * r );
		}

		if (moveTo)
			g.moveTo( x + r * Math.cos( start ), y + r * Math.sin( start ) );
		for (i in 0...n)
			subArc( start + i * step, start + (i + 1) * step );
	}
}