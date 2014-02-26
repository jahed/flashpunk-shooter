package io.jahed.shooter {
	import net.flashpunk.debug.Console;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class MapOne extends World {
		
		public function MapOne() {
			
		}
		
		override public function begin():void {
			super.begin();
		
			var player:Player = new Player()
			
			add(player);
			add(new Ally(player, -1, -1));
			add(new Ally(player, -1, 1));
			add(new Ally(player, 1, 0));
			add(new Enemy(100));
			add(new Enemy(200));
		}
		
		override public function end():void {
			super.end();
		}
	}
}
