package com.watabou.compass.data.layers;

class Layer {

	public var under : Layer = null;
	public var above : Layer = null;

	public function new() {}

	public function draw( brush:Brush ) {
		if (under != null)
			under.draw( brush );

		drawCore( brush );

		if (above != null)
			above.draw( brush );
	}

	private function drawCore( brush:Brush ) {}

	public function addAbove( layer:Layer ) {
		if (above == null)
			above = layer
		else
			above.addAbove( layer );
	}

	public function addUnder( layer:Layer ) {
		if (under == null)
			under = layer
		else
			under.addUnder( layer );
	}
}
