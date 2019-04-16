package com.watabou.compass.data.marks;

import openfl.geom.Point;

import com.watabou.utils.Random;

import com.watabou.compass.data.layers.Layer;
import com.watabou.compass.data.layers.LayerRow;

using com.watabou.utils.GraphicsExtender;
using com.watabou.utils.PointExtender;

class MarkSector extends Mark {

	private var rSize   : Float;
	private var aSize   : Float;

	public function new( rSize:Float, aSize:Float ) {
		this.rSize = rSize;
		this.aSize = aSize * Math.PI;
	}

	override public function draw( brush:Brush, p:Point, a:Float ) {
		var ca = p.atan();
		var a1 = ca - aSize / 2;
		var a2 = ca + aSize / 2;
		var r1 = p.length + rSize / 2;
		var r2 = p.length - rSize / 2;
		brush.paint( primary );
		brush.g.drawArc( 0, 0, r1, a1, a2 );
		brush.g.lineToPoint( Point.polar( r2, a2 ) );
		brush.g.drawArc( 0, 0, r2, a2, a1, false );
		brush.g.lineToPoint( Point.polar( r1, a1 ) );
		brush.end();
	}

	public static function random( size:Float, n:Int ):MarkSector {
		return new MarkSector( 2*size * Random.normal(), 2/n * Random.normal() );
	}

	public static function scale( radius:Float, thickness:Float, n:Int ):Layer {
		var ofs = 1/n / 2;
		var white = new MarkSector( thickness, 1/n );
		var base = new LayerRow( radius, n, ofs, white );

		var black = new MarkSector( thickness, 1/n );
		black.primary = false;
		base.addUnder( new LayerRow( radius, n, 1/n + ofs, black ) );

		return base;
	}
}
