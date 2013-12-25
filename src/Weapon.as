package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;

	public class Weapon extends Entity {
		[Embed(source="assets/shoot.mp3")] private const SHOOT:Class;
		private var shoot:Sfx;
		
		protected var owner:Entity;
		private var relativeX:Number;
		private var relativeY:Number;
		
		private var fireTrigger:Function;
		private var releaseTrigger:Function;
		private var fireRate:Number = 0.1;
		private var fireWait:Number = fireRate;
		
		public function Weapon() {
			name = "weapon";
			type = "weapon";
			this.collidable = false;
			
			shoot = new Sfx(SHOOT);
		}
		
		public function init(owner:Entity, relativeX:Number, relativeY:Number):Weapon {
			this.owner = owner;
			this.layer = owner.layer;
			this.relativeX = relativeX;
			this.relativeY = relativeY;
			
			updatePosition();
			
			return this;
		}
		
		public function setFireRate(newRate:Number):void {
			fireRate = newRate;
			fireWait = fireRate;
		}
		
		public function setReleaseCondition(func:Function):void {
			this.releaseTrigger = func;
		}
		
		public function setFireCondition(func:Function):void {
			this.fireTrigger = func;
		}
		
		public function isOwner(entity:Entity):Boolean {
			return owner == entity;
			//TODO Fix for ally and player (group) ownership.
		}
		
		public function fire():void {
			var bullet:Bullet = FP.world.create(Bullet) as Bullet;
			bullet.init(this);
			shoot.play(1 / (this.layer*this.layer + 1));
		}
		
		override public function update():void {
			updatePosition();
			
			if (this.fireTrigger()) {
				fireWait += FP.elapsed;
				if (fireWait > fireRate) {
					fireWait -= fireRate;
					this.fire();					
				}	
			} else if (this.releaseTrigger()) {
				fireWait = fireRate;
			}
		}
		
		public function updatePosition():void {
			this.x = owner.x + relativeX;
			this.y = owner.y + relativeY;
		}
		
		public function destroy():void {
			world.recycle(this);
		}
	}
}
