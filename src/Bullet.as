package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;

	public class Bullet extends Entity {
		[Embed(source = 'assets/bullet.png')] private static const BULLET:Class;

		private var spriteMap:Spritemap = new Spritemap(BULLET, 48, 16);

		private var speed:Number = 400;
		
		protected var weapon:Weapon;
		
		public function Bullet(weapon:Weapon) {
			name = "bullet";
			type = "bullet";
			spriteMap.add("normal", [0, 1], 20, true);
			setHitbox(40, 15, -8, 0);
			
			this.addGraphic(spriteMap);
			
			this.init(weapon);
			Debug.timeTrace("New Bullet object created");
		}
		
		private function init(weapon:Weapon):void {
			this.weapon = weapon;
			this.layer = weapon.layer;
			if (this.layer != 0) {
				spriteMap.scale = 0.5;
				spriteMap.color = 0x000000;
				spriteMap.tinting = 0.3;
				setHitbox(20, 7.5, 4, 0);
				
			} else {
				spriteMap.scale = 1;
				spriteMap.tinting = 0;
				setHitbox(40, 15, 8, 0);
			}
			this.x = weapon.x;
			this.y = weapon.y;
			spriteMap.play("normal", true);
		}
		
		public function isOwner(entity:Entity):Boolean {
			return weapon == entity || weapon.isOwner(entity);
		}
		
		override public function update():void {
			if (x > FP.width || x < 0 || y < 0 || y > FP.height) {
				this.destroy();
				return;
			}

			x += speed * FP.elapsed;
		}
		
		public function destroy():void {
			pool(this);
		}
		
		private static var bulletPool:Array = [];
		
		public static function create(weapon:Weapon):Bullet {
			if (bulletPool.length == 0) {
				return new Bullet(weapon);
			} else {
				var bullet:Bullet = bulletPool.pop() as Bullet;
				bullet.init(weapon);
				return bullet;
			}
		}
		
		public static function pool(bullet:Bullet):void {
			bullet.world.remove(bullet);
			bullet.weapon = null;
			bulletPool.push(bullet);
		}
	}
}
