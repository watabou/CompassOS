package com.watabou.compass.data.marks;

import com.watabou.geom.polygons.PolyCreate;
import com.watabou.utils.Random;

class MarkRect extends MarkPoly {

	private var w  : Float;
	private var h  : Float;

	public function new( w:Float, h:Float, primary=true ) {

		this.primary = primary;

		proto = PolyCreate.rect( w, h );
	}

	public static function random( size:Float ):MarkRect {
		return new MarkRect( 2*size * Random.normal(), size * Random.normal() );
	}
}
