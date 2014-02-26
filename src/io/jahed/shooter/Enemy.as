package io.jahed.shooter {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Spritemap;

	public class Enemy extends Entity {
		[Embed(source = '/assets/enemy.png')] private const ENEMY:Class;
		
		private var spriteMap:Spritemap;
		private var shoot:Sfx;
		
		private var speed:Number = 150;
		private var hVelocity:Number = 0;
		private var vVelocity:Number = 0;
		
		private var weapon:Weapon;
		private var motionTweenXLeft:VarTween;
		private var motionTweenYUp:VarTween;
		private var motionTweenYDown:VarTween;
		private var amplitude:Number = 20;
		
		public function Enemy(startY:Number) {
			name = "enemy";
			
			spriteMap = new Spritemap(ENEMY, 48, 48);
				spriteMap.add("normal", [0, 1], 30, true);
			spriteMap.flipped = true;
			spriteMap.play("normal");
			spriteMap.color = 0xFF0000;
			spriteMap.tinting = 0;
			this.addGraphic(spriteMap);
			setHitbox(30, 30, -9, -9);
			
			this.x = 600;
			this.y = startY;
			
			var self:Enemy = this;
			
			motionTweenXLeft = new VarTween(function():void {
				destroy();
			});
			
			motionTweenYUp = new VarTween(function():void {
				motionTweenYDown.tween(self, "y", y+2*amplitude, 0.3, Ease.sineOut);
				motionTweenYDown.start();
			}, Tween.PERSIST);
			motionTweenYDown = new VarTween(function():void {
				motionTweenYUp.tween(self, "y", y-2*amplitude, 0.3, Ease.sineOut);
				motionTweenYUp.start();
			}, Tween.PERSIST);
			
			motionTweenXLeft.tween(this, "x", -100, 3);
			motionTweenYUp.tween(this, "y", this.y-this.amplitude, 0.3, Ease.sineOut);
			
			this.addTween(motionTweenXLeft, true);
			this.addTween(motionTweenYUp, true);
			this.addTween(motionTweenYDown, false);
			
			weapon = FP.world.create(Weapon) as Weapon;
			weapon.init(this, 0, 0);
			weapon.setFireCondition(fireCondition);
			weapon.setFireRate(0.3);

		}
		
		private function fireCondition():Boolean {
			return true;
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
		
		public function destroy():void {
			this.world.remove(this);
			this.world.remove(weapon);
		}
	}
}
