package com.watabou.geom;

import openfl.geom.Point;

import com.watabou.geom.GeomUtils;

using com.watabou.utils.ArrayExtender;

class Chaikin {
	public static function render( points:Array<Point>, closed:Bool, order=1, exclude:Array<Point>=null ):Array<Point> {
		if (order <= 0) {
			return points;
		} else {
			points = render( points, closed, order - 1, exclude );
			var n = points.length;

			var result:Array<Point> = [];

			for (i in 1...n - 1) {
				var p = points[i];
				if (exclude == null || !exclude.contains( p )) {
					result.push( GeomUtils.lerp( p, points[i - 1], 0.25 ) );
					result.push( GeomUtils.lerp( p, points[i + 1], 0.25 ) );
				} else {
					result.push( p );
				}
			}

			if (closed) {
				var p = points[n - 1];
				if (exclude == null || !exclude.contains( p )) {
					result.push( GeomUtils.lerp( p, points[n - 2], 0.25 ) );
					result.push( GeomUtils.lerp( p, points[0], 0.25 ) );
				} else {
					result.push( p );
				}

				p = points[0];
				if (exclude == null || !exclude.contains( p )) {
					result.push( GeomUtils.lerp( p, points[n - 1], 0.25 ) );
					result.push( GeomUtils.lerp( p, points[1], 0.25 ) );
				}
				else {
					result.push( p );
				}
			} else {
				result.unshift( points[0] );
				result.push( points[n - 1] );
			}

			return result;
		}
	}
}
