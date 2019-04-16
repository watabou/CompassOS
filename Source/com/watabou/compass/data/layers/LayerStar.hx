package com.watabou.compass.data.layers;

import openfl.geom.Point;

import com.watabou.geom.Chaikin;
import com.watabou.geom.GeomUtils;
import com.watabou.geom.polygons.PolyTransform;
import com.watabou.utils.Random;

using com.watabou.utils.ArrayExtender;
using com.watabou.utils.GraphicsExtender;
using com.watabou.utils.PointExtender;

class LayerStar extends Layer {

	public var radius1 : Float;
	public var radius2 : Float;

	public var n : Int;

	public var angle : Float;

	public var shaded   : Bool;
	public var primary  : Bool = true;

	private var perSide : Int;
	private var perTip  : Int;
	private var shape   : Array<Point>;

	public static var curvRate = 0.0;

	public static var SHADE_LEFT = false;

	public function new( radius1:Float, radius2:Float, n=4, angle=0.0, shaded=true ) {
		super();

		this.radius1 = radius1;
		this.radius2 = radius2;
		this.angle = angle * Math.PI;
		this.n = n;
		this.shaded = shaded;

		buildShape();
	}

	override private function drawCore( brush:Brush ) {
		if (shaded) {
			brush.fill( true );
			drawShape( brush );
			brush.end();

			brush.fill( false );
			drawFaces( brush, SHADE_LEFT );
			brush.end();

			brush.draw();
			drawShape( brush );
			if (Brush.MEDIUM != Brush.DARK) {
				var start = (shape.length - 1);
				for (i in 0...n * 2) {
					brush.g.moveTo( 0, 0 );
					brush.g.lineToPoint( shape[start % shape.length] );
					start += (perSide - 1);
				}
			}
			brush.end();
		} else {
			brush.paint( primary );
			drawShape( brush );
			brush.end();
		}
	}

	private function drawShape( brush:Brush ) {
		brush.g.drawPolygon( shape );
	}

	private function drawFaces( brush:Brush, left:Bool ) {
		for (i in 0...n) {
			brush.g.moveTo( 0, 0 );

			var start = i * perTip + (shape.length - 1) + (left ? 0 : perSide - 1);
			for (j in 0...perSide) {
				var p = shape[(start + j) % shape.length];
				brush.g.lineToPoint( p );
			}
		}
	}

	private function buildShape() {
		var side = getSide();
		perSide = side.length;
		perTip = (perSide - 1) * 2;

		side = [for (j in 2...side.length) {
			var p = side[side.length - j];
			new Point( p.x, -p.y );
		}].concat( side );

		shape = [];
		for (i in 0...n) {
			var a = 2*Math.PI * i / n + angle;
			shape.addAll( PolyTransform.rotate( side, a ) );
		}
	}

	private function getSide():Array<Point> {
		var a = Math.PI / n;
		var p1 = Point.polar( radius1, 0 );
		var p2 = Point.polar( radius2, a );
		if (curvRate == 0)
			return [p1, p2];

		var c = GeomUtils.lerp( p1, p2 );

		var a = p2.x > 1e-6 ? new Point( p2.x + (p2.y * p2.y) / p2.x, 0 ) : new Point( p2.x, 0 );
		var b = new Point( (p1.x * p1.x - p2.x * p2.x - p2.y * p2.y) / (2 * (p1.x - p2.x)), 0 );
		var p0 = Point.distance( c, a ) < Point.distance( c, b ) ? a : b;

		var p3 = GeomUtils.lerp( c, p0, curvRate );
		var side = [p1, p3, p2];
		return Chaikin.render( side, false, 3 );
	}

	public function scale( n:Int, s:Float ):Float {
		var start = n * perTip + (shape.length - 1);
		var zero = shape[start % shape.length].length;
		for (i in 1...perTip) {
			var p = shape[(start + i) % shape.length];
			p.normalize( zero + (p.length - zero) * s );
		}

		return shape[(start + perSide - 1) % shape.length].length;
	}

	public static function randomBg( r:Float ) {
		var n = (Random.bool() ? 8 : 16);
		var o = (Random.bool( 2/3 ) ? 0 : 1/n);
		var star = new LayerStar( r, r * (0.5 + 0.5 * Random.normal()), n, o, false );
		return star;
	}
}
