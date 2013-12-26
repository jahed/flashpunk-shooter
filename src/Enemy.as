package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Spritemap;

	public class Enemy extends Entity {
		[Embed(source = 'assets/enemy.png')] private const ENEMY:Class;
		
		private var spriteMap:Spritemap;
		private var shoot:Sfx;
		
		private var speed:Number = 150;
		private var hVelocity:Number = 0;
		private var vVelocity:Number = 0;
		
		private var weapon:Weapon;
		
		public function Enemy() {
			name = "enemy";
			
			spriteMap = new Spritemap(ENEMY, 48, 48);
				spriteMap.add("normal", [0, 1], 30, true);
			spriteMap.flipped = true;
			spriteMap.play("normal");
			spriteMap.color = 0xFF0000;
			spriteMap.tinting = 0;
			this.addGraphic(spriteMap);
			setHitbox(30, 30, -9, -9);
			
			this.x = 300;
			this.y = 200;
		}
		
		override public function update():void {
			var bulletCollision:Bullet = collideOnLayer("bullet", x, y) as Bullet;

			if (bulletCollision && !bulletCollision.isOwner(this)) {
				bulletCollision.destroy();
			}
		}
		
		public function collideOnLayer(type:String, x:Number, y:Number):Entity {
			var collisions:Array = [];
			this.collideInto(type, x, y, collisions);
			for (var index:String in collisions) {
				if (collisions[index] && collisions[index].layer == this.layer) {
					return collisions[index];
				}
			}
			return null;
		}
	}
}
