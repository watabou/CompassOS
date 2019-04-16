package com.watabou.compass.data.marks;

import openfl.geom.Point;

import com.watabou.utils.Random;

class MarkRhombus extends MarkPoly {

	public function new( w:Float, h:Float, aSym=1.0 ) {
		proto = [new Point( -w/2, 0 ), new Point( 0, -h/2 ), new Point( w/2 * aSym, 0 ), new Point( 0, h/2 )];
	}

	public static function random( size:Float ):MarkRhombus {
		return new MarkRhombus(
			2 * Random.normal() * size,
			2 * Random.normal() * size,
			Random.bool() ? 1 : Random.float() * 2 );
	}
}
