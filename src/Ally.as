package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;

	public class Ally extends Entity {
		[Embed(source = 'assets/ally.png')] private const ALLY:Class;
		[Embed(source = "assets/konami.mp3")] private const SHOOT:Class;
		
		private var spriteMap:Spritemap;
		private var shoot:Sfx;
		
		private var speed:Number = 100 + Math.random() * 50;
		private var playerDistance:Number = 50;
		
		private var weapon:Weapon;
		private var fireRate:Number = 0.1;
		private var fireWait:Number = fireRate;
		
		private var player:Player;
		private var anchorX:Number;
		private var anchorY:Number;
		
		
		public function Ally(player:Player, anchorX:Number, anchorY:Number) {
			name = "ally";
			this.player = player;
			this.anchorX = anchorX;
			this.anchorY = anchorY;
			
			spriteMap = new Spritemap(ALLY, 32, 32);
				spriteMap.smooth = false;
				spriteMap.scale = 0.5;
				spriteMap.color = 0x000000;
				spriteMap.tinting = 0.3;
				spriteMap.add("normal", [0, 1], 30, true);
			spriteMap.play("normal");
			
			this.addGraphic(spriteMap);
			setHitbox(18*spriteMap.scale, 23*spriteMap.scale, -6*spriteMap.scale, -4*spriteMap.scale);

			shoot = new Sfx(SHOOT);
			
			this.layer = 5;
			this.weapon = Weapon.create(this, 4, 4);
			this.weapon.setFireCondition(fireCondition);
			this.weapon.setReleaseCondition(releaseFireCondition);
			FP.world.add(this.weapon); //Assuming current world
		}
		
		private function fireCondition():Boolean {
			return Input.mouseDown && !chargeCondition();
		}
		
		private function releaseFireCondition():Boolean {
			return Input.mouseReleased;
		}
		
		private function chargeCondition():Boolean {
			return Input.mousePressed && player.collidePoint(
				player.x, player.y, Input.mouseX, Input.mouseY
			);
		}
		
		override public function update():void {
			this.moveTowards(
				player.x + player.halfWidth + anchorX * playerDistance,
				player.y + player.halfHeight + anchorY * playerDistance,
				speed * FP.elapsed
			);
			
			if (chargeCondition()) {
				player.flash();
			}
			
			// Assign the collided Bullet Entity to a temporary var.
			var bulletCollision:Bullet = collideOnLayer("bullet", x, y) as Bullet;

			// Check if b has a value (true if a Bullet was collided with).
			if (bulletCollision && !bulletCollision.isOwner(this)) {
				bulletCollision.destroy();
			}
		}
		
		public function collideOnLayer(type:String, x:Number, y:Number):Entity {
			var entity:Entity = collide(type, x, y);
			if (entity && entity.layer == this.layer) return entity;
			return null;
		}
	}
}
