package com.watabou.compass.data;

import com.watabou.utils.Random;

import com.watabou.compass.data.marks.*;
import com.watabou.compass.data.layers.*;

using com.watabou.utils.ArrayExtender;

class Rose {

	public var radius : Float;

	public var n : Float;
	public var e : Float;
	public var s : Float;
	public var w : Float;

	public var layers : Array<Layer>;

	private var gamma : Float;

	public function new( r:Float, level:Int ) {

		radius = n = e = s = w = r;
		layers = [];

		gamma = Math.pow( 2, 1.5 * (Random.float() - 0.5) );

		LayerStar.curvRate = (Random.bool( 1/4 ) ? Random.float() : 0);

		if (level > 2 && Random.bool( 1/4 ))
			double()
		else {
			basic();
			if (level > 2)
				principal();
		}
		if (level > 3)
			halfWinds();

		// Knob
		var stars = getStars();
		if (stars[0].n == 4 || Random.bool())
			layers.push( knob( stars[0].radius2 ) );

		// Simple circle
		if (Random.bool())
			layers.unshift( LayerRing.circle( r * Random.normal() ) );

		// Ring
		if (Random.bool())
			layers.push( randomRing( r * (0.1 + 0.9 * Random.float()) ) );

		// Base
		if (Random.bool()) {
			var r = 0.0;
			for (star in stars)
				if (r < star.radius2)
					r = star.radius2;
			layers.unshift( randomBase( r ) );
		}

	//	layers.push( MarkLily.layer( n ) );
	}

	private function r2r( ratio:Float ):Float {
		return Math.pow( ratio, gamma ) * radius;
	}

	public function getRadius():Float {
		return (n + e + s + w) / 4;
	}

	private function basic() {
		var star:LayerStar;
		var ni = 3, si = 1;

		if (Random.bool( 1/8 )) {
			var r2 = 0.2 + Random.normal2() * 0.2;

			star = new LayerStar( radius, r2r( r2 ), 2 );
			layers.push( star );

			star = new LayerStar( radius, r2r( r2 ), 2, 1/2 );
			layers.push( star );

			ni = 1; si = 0;
		} else {
			var r2 = 0.2 + Random.normal2() * 0.2;
			star = new LayerStar( radius, r2r( r2 ) );
			layers.push( star );
		}

		switch (Random.int( 0, 12 )) {
			case 0:
				n = star.scale( ni, 1.2 + 0.6 * Random.normal() );
			case 1:
				var scale = 1.2 + 0.4 * Random.normal();
				n = star.scale( ni, scale );
				s = star.scale( si, scale );
		}
	}

	private function knob( r:Float ):Layer {
		var layer = new Layer();

		if (Random.bool( Math.sqrt( r / radius ) )) {

			var primary = Random.bool( 2/3 );
			while (r > 0) {
				var disk = LayerRing.disk( r );
				disk.primary = primary;
				layer.addAbove( disk );

				r -= radius * Random.normal() * 0.2;
				primary = (!primary || Random.bool());
			}
		}

		return layer;
	}

	private function double() {
		var r2 = 0.3 + Random.normal2() * 0.2;
		var star = new LayerStar( radius, r2r( r2 ), 8 );
		layers.push( star );

		if (Random.bool()) {
			var scale = 0.5 + 0.5 * Random.normal();
			for (i in 0...4)
				star.scale( i * 2 + 1, scale );
		}
	}

	private function principal() {

		var r1 = 1 - Random.normal() * 0.2;
		var r2 = 0.2 + Random.normal2() * 0.1;
		var cross = new LayerStar( r2r( r1 ), r2r( r2 ), 1/4 );
		if (Random.bool( 1/4 ))
			layers.push( cross )
		else
			layers.unshift( cross );

		var r2 = r1 * (1 - Random.normal() * 0.1);
		var ring = new LayerRing( r2r( r1 ), r2r( r2 ) );
		ring.primary = Random.bool( 2/3 );
		cross.addUnder( ring );
	}

	private function halfWinds() {

		var r1 = 0.5 + 0.5 * Random.normal();
		var r2 = r1 * (0.2 + Random.normal2() * 0.2);
		var cross = new LayerStar( r2r( r1 ), r2r( r2 ), 8, 1/8, false );
		if (Random.bool())
			cross.primary = false;
		layers.unshift( cross );
	}

	private function getStars():Array<LayerStar> {
		var stars:Array<LayerStar> = [];

		for (i in 0...layers.length) {
			var layer = layers[layers.length - 1 - i];
			if (Std.is( layer, LayerStar ))
				stars.push( cast layer );
		}

		return stars;
	}

	private function randomRing( r:Float ):Layer {
		var layer = new Layer();

		var size = Math.min( radius * Random.normal() * 0.1, r );

		if (Random.bool( 1/5 ))
			return MarkSector.scale( r, size * Math.sqrt( r / radius ), (1 << Random.int( 2, 5 )) );

		var black = false;
		var baseRing = false;

		if (Random.bool()) {
			var ring:LayerRing = Random.bool() ? LayerRing.circle( r ) : new LayerRing( r + size, r - size );
			ring.primary = Random.bool();
			black = !ring.primary && (ring.radius2 < ring.radius1);
			layer.addAbove( ring );
			baseRing = true;
		}

		if (Random.bool() || !baseRing) {

			var n = (1 << Random.int( 3, 7 ));

			var marks = [
				MarkSector.random( size, n ), MarkSector.random( size, n ),
				MarkCircle.random( size ), MarkCircle.random( size ),
				MarkRect.random( size ),
				MarkRhombus.random( size ), MarkRhombus.random( size )
			];
			if (!black) marks.addAll( [
				MarkNotch.random( size ), MarkNotch.random( size ),
				new MarkDot()
			] );

			var mark:Mark = marks.pick();
			mark.primary = black || Random.bool( 2/3 );
			var row = new LayerRow( r, n, 0, mark );
			layer.addAbove( row );

			if (Random.bool()) {
				mark = marks.pick();
				mark.primary = black || Random.bool( 2/3 );
				var phase = n < 64 && Random.bool( 2/3 );
				var row = new LayerRow( (phase ? r : r - 2*size * Random.normal()), n, (phase ? 1/n : 0), mark );
				layer.addAbove( row );
			}
		}

		return layer;
	}

	private function randomBase( r:Float ):Layer {
		r += (radius - r) * Math.sqrt( Random.float() );
		return switch (Random.int( 0, 3 )) {
			case 0: LayerStar.randomBg( r );
			case 1: MarkRay.rays( r );
			case 2: randomRing( r );
			default: null;
		}
	}
}
