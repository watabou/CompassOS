package com.watabou.compass.data.marks;

import openfl.geom.Point;

import com.watabou.utils.Random;

class MarkCircle extends Mark {

	private var radius  : Float;

	public function new( radius:Float ) {
		this.radius = radius;
	}

	override public function draw( brush:Brush, p:Point, a:Float ) {
		brush.paint( primary );
		brush.g.drawCircle( p.x, p.y, radius );
		brush.end();
	}

	public static function random( size:Float ):MarkCircle {
		return new MarkCircle( size * Random.normal() );
	}
}
