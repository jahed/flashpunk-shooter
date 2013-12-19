package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;

	public class Bullet extends Entity {
		[Embed(source = 'assets/bullet.png')] private static const BULLET:Class;

		private var spriteMap:Spritemap = new Spritemap(BULLET, 48, 16);

		private var speed:Number = 400;
		
		protected var shooter:Entity;
		
		public function Bullet(shooter:Entity) {
			name = "bullet";
			type = "bullet";			
			spriteMap.add("normal", [0, 1], 20, true);
			setHitbox(40, 15, -8, 0);
			
			this.addGraphic(spriteMap);
			
			this.init(shooter);
			Debug.timeTrace("New Bullet object created");
		}
		
		private function init(shooter:Entity):void {
			this.shooter = shooter;
			this.layer = shooter.layer;
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
			this.x = shooter.x + shooter.width - this.width / 2;
			this.y = shooter.y + shooter.height / 2 - this.height / 2;
			spriteMap.play("normal", true);
		}
		
		public function isShooter(entity:Entity):Boolean {
			return shooter == entity;
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
		
		public static function create(shooter:Entity):Bullet {
			if (bulletPool.length == 0) {
				return new Bullet(shooter);
			} else {
				var bullet:Bullet = bulletPool.pop() as Bullet;
				bullet.init(shooter);
				return bullet;
			}
		}
		
		public static function pool(bullet:Bullet):void {
			bullet.world.remove(bullet);
			bullet.shooter = null;
			bulletPool.push(bullet);
		}
	}
}
