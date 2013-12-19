package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Spritemap;

	public class Player extends Entity {
		[Embed(source = 'assets/player.png')] private const PLAYER:Class;
		[Embed(source = "assets/konami.mp3")] private const SHOOT:Class;
		
		private var spriteMap:Spritemap;
		private var shoot:Sfx;
		
		private var speed:Number = 150;
		private var hVelocity:Number = 0;
		private var vVelocity:Number = 0;
		
		private var fireRate:Number = 0.1;
		private var fireWait:Number = fireRate;
		
		private var tintTween:VarTween;
		private var resetTintTween:VarTween;

		public function Player() {
			name = "player";
			
			spriteMap = new Spritemap(PLAYER, 32, 32);
				spriteMap.add("normal", [2, 3], 30, true);
				spriteMap.add("up", [0, 1], 120, true);
				spriteMap.add("down", [4, 5], 120, true);
			spriteMap.play("normal");
			spriteMap.color = 0xFF0000;
			spriteMap.tinting = 0;
			this.addGraphic(spriteMap);
			setHitbox(16, 18, -7, -6);
			this.centerOrigin();

			shoot = new Sfx(SHOOT);

			Input.define("up", Key.W, Key.UP);
			Input.define("down", Key.S, Key.DOWN);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			
			resetTintTween = new VarTween(null, Tween.PERSIST);
			resetTintTween.active = false;
			addTween(resetTintTween);
			
			tintTween = new VarTween(function():void {
				resetTintTween.tween(spriteMap, "tinting", 0, 0.5);
				resetTintTween.start();
			}, Tween.PERSIST);
			tintTween.tween(spriteMap, "tinting", 0.8, 0.3);
			tintTween.active = false;
			addTween(tintTween);
		}
		
		override public function update():void {
			if (Input.pressed("left")) {
				hVelocity = -speed;
			}
			if (Input.pressed("right")) {
				hVelocity = speed;
			}
			if (Input.pressed("up")) {
				vVelocity = -speed;
			}
			if (Input.pressed("down")) {
				vVelocity = speed;
			}
			
			if (Input.released("left")) {
				hVelocity = Input.check("right") ? speed : 0;
			}
			if (Input.released("right")) {
				hVelocity = Input.check("left") ? -speed : 0;
			}
			if (Input.released("up")) {
				vVelocity = Input.check("down") ? speed : 0;
			}
			if (Input.released("down")) {
				vVelocity = Input.check("up") ? -speed : 0;
			}
			
			spriteMap.play(vVelocity > 0 ? "down" : vVelocity < 0 ? "up" : "normal", false);
			
			x += hVelocity * FP.elapsed;
			y += vVelocity * FP.elapsed;
			
			FP.clampInRect(this, 0, 0, FP.width - this.width, FP.height - this.height);
			
			if (Input.check(Key.SPACE)) {
				//shoot.play(0.1, 1);
				fireWait += FP.elapsed;
				if (fireWait > fireRate) {
					fireWait -= fireRate;
					this.world.add(Bullet.create(this));					
				}
			} else if (Input.released(Key.SPACE)) {
				fireWait = fireRate;
			}
			
			// Assign the collided Bullet Entity to a temporary var.
			var bulletCollision:Bullet = collideOnLayer("bullet", x, y) as Bullet;

			// Check if b has a value (true if a Bullet was collided with).
			if (bulletCollision && !bulletCollision.isShooter(this)) {
				bulletCollision.destroy();
			}
		}
		
		public function flash():void {
			if(!tintTween.active && !resetTintTween.active) tintTween.start();
		}
		
		public function collideOnLayer(type:String, x:Number, y:Number):Entity {
			var entity:Entity = collide(type, x, y);
			if (entity && entity.layer == this.layer) return entity;
			return null;
		}
	}
}