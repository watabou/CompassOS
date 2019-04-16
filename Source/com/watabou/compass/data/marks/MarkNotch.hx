package com.watabou.compass.data.marks;

import com.watabou.geom.polygons.PolyTransform;
import com.watabou.utils.Random;

class MarkNotch extends MarkRect {

	public function new( len1:Float, len2=0.0 ) {

		if (len1 < 0) {
			len2 = -len1;
			len1 = 0;
		}
		super( len1 + len2, Brush.STROKE, false );

		proto = PolyTransform.translate( proto, (len1 - len2) / 2, 0 );
		isLinework = true;
	}

	public static function random( size:Float ):MarkNotch {
		return switch(Random.int( 0, 3 )) {
			case 0: new MarkNotch( size );
			case 1: new MarkNotch( 0, size );
			default: new MarkNotch( size * Random.normal(), size * Random.normal() );
		}
	}
}
