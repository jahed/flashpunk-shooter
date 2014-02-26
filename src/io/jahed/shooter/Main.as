package io.jahed.shooter {
	import flash.display.StageScaleMode;
	import net.flashpunk.debug.Console;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;

	public class Main extends Engine {
		
		public function Main() {
			super(400, 300, 60, false);
			FP.screen.scale = 2;
			FP.screen.color = 0x000000;
			FP.console.enable();
			FP.console.toggleKey = Key.NUMPAD_0;
			FP.volume = 0.3;
		}

		override public function init():void {
			FP.screen.resize();

			FP.world = new MapOne;
		}
		
		override public function setStageProperties():void {
			super.setStageProperties();
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
		}
	}
}