package com.watabou.compass;

import openfl.display.Graphics;

class Brush {

	public static var STROKE = 2;

	public static var PAPER  = 0xeeeeee;
	public static var LIGHT  = 0xeeeeee;
	public static var MEDIUM = 0x444444;
	public static var DARK   = 0x444444;

	private static var bw = false;

	public var g : Graphics;

	public function new( g:Graphics ) {
		this.g = g;
	}

	public function paint( primary=true ) {
		fill( primary );
		draw();
	}

	public function fill( primary=false ) {
		g.beginFill( primary ? LIGHT : MEDIUM );
	}

	public function draw() {
		g.lineStyle( STROKE, DARK, 1.0 );
	}

	public function lineFill() {
		g.beginFill( DARK );
	}

	public function end() {
		g.endFill();
	}

	public static function paletteDef() {
		PAPER = 0xeeeeee;
		LIGHT = 0xeeeeee;
		MEDIUM = 0x444444;
		DARK = 0x444444;
	}

	public static function paletteBW() {
		PAPER = 0xffffff;
		LIGHT = 0xffffff;
		MEDIUM = 0xffffff;
		DARK = 0x000000;
	}

	public static function toggle() {
		if (bw = !bw)
			paletteBW()
		else
			paletteDef();
	}
}
