package com.watabou.utils;

class ArrayExtender {

	public static inline function append<T>( a:Array<T>, b:Array<T> )
		for (e in b) a.push( e );

	public static function shuffle<T>( a:Array<T> ):Array<T> {
		var result = [];
		for (e in a) {
			result.insert( Std.int( Random.float() * (result.length + 1) ), e );
		}
		return result;
	}

	public static function random<T>( a:Array<T> ):T
		return a[Std.int( Random.float() * a.length )];

	public static function pick<T>( a:Array<T> ):T {
		var index = Std.int( Random.float() * a.length );
		var item = a[index];
		a.splice( index, 1 );
		return item;
	}

	public static function fallOff<T>( a:Array<T>, f=2.0 ):T
		return a[Std.int( Math.pow( Random.float(), f ) * a.length )];

	public static function subset<T>( a:Array<T>, n:Int ):Array<T>
		return shuffle( a ).slice( 0, n );

	public static function weighted<T>( a:Array<T>, weights:Array<Float> ):T {
		var z = Random.float() * sum( weights );
		var acc = 0.0;
		for (i in 0...a.length)
			if (z <= (acc += weights[i]))
				return a[i];

		return a[0];
	}

	public static inline function weightedIndex( weights:Array<Float> ):Int
		return weighted( indices( weights ), weights );

	public static inline function contains<T>( a:Array<T>, value:T ):Bool
		return (a.indexOf( value ) != -1);

	public static function isEmpty<T>( a:Array<T> ):Bool
		return (a.length == 0);

	public static inline function first<T>( a:Array<T> ):T
		return a[0];

	public static inline function second<T>( a:Array<T> ):T
		return a[1];

	public static inline function last<T>( a:Array<T> ):T
		return a[a.length - 1];

	public static function min<T>( a:Array<T>, f:T->Float ):T {
		var result = a[0];
		var min = f( result );
		for (i in 1...a.length) {
			var element = a[i];
			var measure = f( element );
			if (measure < min) {
				result = element;
				min = measure;
			}
		}
		return result;
	}

	public static function max<T>( a:Array<T>, f:T->Float ):T {
		var result = a[0];
		var max = f( result );
		for (i in 1...a.length) {
			var element = a[i];
			var measure = f( element );
			if (measure > max) {
				result = element;
				max = measure;
			}
		}
		return result;
	}

	public static function every<T>( a:Array<T>, test:T->Bool ):Bool {
		for (e in a)
			if (!test( e ))
				return false;
		return true;
	}

	public static function some<T>( a:Array<T>, test:T->Bool ):Bool {
		for (e in a)
			if (test( e ))
				return true;
		return false;
	}

	public static function count<T>( a:Array<T>, test:T->Bool ):Int {
		var count = 0;
		for (e in a)
			if (test( e ))
				count++;
		return count;
	}

	public static inline function indices<T>( a:Array<T> ):Array<Int>
		return [for (i in 0...a.length) i];

	public static function sum( a:Array<Float> ):Float {
		var sum = 0.0;
		for (f in a) sum += f;
		return sum;
	}

	public static function map<T, S>( a:Array<T>, f:T->S):Array<S>
		return [for (el in a) f( el )];

	public static function replace<T>( a:Array<T>, el:T, newEls:Array<T> ) {
		var index = a.indexOf( el );
		a[index++] = newEls[0];
		for (i in 1...newEls.length)
			a.insert( index++, newEls[i] );
	}

	public static function add<T>( a:Array<T>, el:T ):Bool
		if (a.indexOf( el ) == -1) {
			a.push( el );
			return true;
		} else
			return false;

	public static function clean<T>( a:Array<T> ):Array<T>
		return [for (i in 0...a.length) if (a.indexOf( a[i] ) == i) a[i]];

	public static function intersect<T>( a:Array<T>, b:Array<T> ):Array<T>
		return [for (el in a) if (b.indexOf( el ) != -1) el];

	public static function addAll<T>( a:Array<T>, b:Array<T> )
		for (el in b)
			if (a.indexOf( el ) == -1)
				a.push( el );

	public static function collect<T>( a:Array<Array<T>> ):Array<T> {
		var result = new Array<T>();
		for (e in a)
			addAll( result, e );
		return result;
	}

	public static function union<T>( a:Array<T>, b:Array<T> ):Array<T>
		return a.concat( [for (el in b) if (a.indexOf( el ) == -1) el] );

	public static function removeAll<T>( a:Array<T>, b:Array<T> )
		for (el in b) a.remove( el );

	public static function difference<T>( a:Array<T>, b:Array<T> ):Array<T>
		return [for (el in a) if (b.indexOf( el ) == -1) el];

	public static function flatten<T>( a:Array<Array<T>> ):Array<T>
		if (a.length == 0)
			return []
		else {
			var result = a[0].copy();
			for (i in 1...a.length)
				result = result.concat( a[i] );
			return result;
		}

	public static function uflatten<T>( a:Array<Array<T>> ):Array<T>
		if (a.length == 0)
			return []
		else {
			var result = a[0].copy();
			for (i in 1...a.length)
				result = union( result, a[i] );
			return result;
		}

	public static function equals<T>( a:Array<T>, b:Array<T> )
		if (a.length != b.length)
			return false
		else if (a.length == 0)
			return true
		else {
			for (el in a)
				if (b.indexOf( el ) == -1)
					return false;
			return true;
		}
}
