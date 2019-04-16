package com.watabou.compass;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.system.System;
import openfl.ui.Keyboard;

import com.watabou.utils.Random;

import com.watabou.compass.data.Rose;

class Main extends Sprite {

	private var rose : Rose;
	private var view : RoseView;

	public function new() {
		super();

		Random.reset();
		reroll();

		stage.addEventListener( Event.RESIZE, onResize );
		stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}

	private function onResize( e:Event ) {
		layout();
	}

	private function onKeyDown( e:KeyboardEvent ) {
		e.preventDefault();

		switch (e.keyCode ) {
			case Keyboard.ENTER:
				reroll();
			case Keyboard.SPACE:
				Brush.toggle();
				update();
			case Keyboard.ESCAPE:
				System.exit( 0 );
		}
	}

	private function layout() {
		var w = stage.stageWidth;
		var h = stage.stageHeight;

		view.x = w / 2;
		view.y = h / 2;

		view.scaleX = view.scaleY = 0.6 * Math.min( w, h ) / (rose.getRadius() * 2);
	}

	private function update() {
		stage.color = Brush.PAPER;

		if (view != null)
			removeChild( view );

		view = new RoseView( rose );
		addChildAt( view, 0 );

		layout();
	}

	private function reroll() {
		rose = new Rose( 300, Random.int( 2, 6 ) );
		update();
	}
}
