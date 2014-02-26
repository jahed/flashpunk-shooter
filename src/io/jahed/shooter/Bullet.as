package io.jahed.shooter {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;

	public class Bullet extends Entity {
		[Embed(source = '/assets/bullet.png')] private static const BULLET:Class;

		private var spriteMap:Spritemap = new Spritemap(BULLET, 48, 16);

		private var speed:Number = 400;
		
		protected var weapon:Weapon;
		
		public function Bullet() {
			name = "bullet";
			type = "bullet";
			spriteMap.add("normal", [0, 1], 20, true);
			
			this.addGraphic(spriteMap);
		}
		
		public function init(weapon:Weapon):Bullet {
			this.weapon = weapon;
			this.layer = weapon.layer;
			if (this.layer != 0) {
				spriteMap.scale = 0.5;
				spriteMap.color = 0x0000AA;
				spriteMap.tinting = 0.3;
				setHitbox(20, 7.5, 0, 0);
				
			} else {
				spriteMap.scale = 1;
				spriteMap.tinting = 0;
				setHitbox(40, 15, 0, 0);
			}
			this.x = weapon.x;
			this.y = weapon.y;
			spriteMap.play("normal", true);
			
			return this;
		}
		
		public function isOwner(entity:Entity):Boolean {
			return weapon != null && (weapon == entity || weapon.isOwner(entity));
		}
		
		override public function update():void {
			if (x > FP.width || x < 0 || y < 0 || y > FP.height) {
				this.destroy();
			}
			
			x += speed * FP.elapsed;
		}
		
		public function destroy():void {
			world.recycle(this);
		}
	}
}
