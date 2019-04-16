package com.watabou.utils;

class Random {

	private static inline var g = 48271.0;
	private static inline var n = 2147483647;

	private static var seed = 1;

	private static var saved = -1;

	public static function reset( seed=-1 )
		Random.seed = (seed != -1 ? seed : Std.int( Date.now().getTime() % n ));

	public static function save():Int return (saved = seed);

	public static function restore( value=-1 )
		if (value != -1)
			seed = value
		else if (saved != -1) {
			seed = saved;
			saved = -1;
		}

	public static inline function getSeed():Int return seed;

	public static inline function next():Int
		return (seed = Std.int( (seed * g) % n ));

	public static inline function float():Float
		return next() / n;

	public static inline function float2():Float {
		var f = Random.float();
		return f * f * f;
	}

	public static inline function normal():Float
		return (float() + float() + float()) / 3;

	public static inline function normal2():Float
		return (normal() * 2 - 1);

	public static inline function int( min:Int, max:Int ):Int
		return Std.int( min + next() / n * (max - min) );

	public static inline function frac( f:Float ):Int
		return Std.int( f ) + (bool( f - Std.int( f ) ) ? 1 : 0);

	public static inline function bool( chance=0.5 ):Bool
		return float() < chance;

	public static function fuzzy( f=1.0 ):Float {
		return if (f == 0)
			0.5
		else
			(1 - f) / 2 + f * normal();
	}
}