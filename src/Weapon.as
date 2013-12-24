package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;

	public class Weapon extends Entity {
		
		protected var owner:Entity;
		private var relativeX:Number;
		private var relativeY:Number;
		
		private var fireTrigger:Function;
		private var releaseTrigger:Function;
		private var fireRate:Number = 0.1;
		private var fireWait:Number = fireRate;
		
		public function Weapon(owner:Entity, relativeX:Number, relativeY:Number) {
			name = "weapon";
			type = "weapon";
			this.collidable = false;
			this.init(owner, relativeX, relativeY);
		}
		
		private function init(owner:Entity, relativeX:Number, relativeY:Number):void {
			this.owner = owner;
			this.layer = owner.layer;
			this.relativeX = relativeX;
			this.relativeY = relativeY;
			
			updatePosition();
		}
		
		public function setFireRate(newRate:Number) {
			fireRate = newRate;
			fireWait = fireRate;
		}
		
		public function setReleaseCondition(func:Function) {
			this.releaseTrigger = func;
		}
		
		public function setFireCondition(func:Function) {
			this.fireTrigger = func;
		}
		
		public function isOwner(entity:Entity):Boolean {
			return owner == entity;
		}
		
		public function fire():void {
			this.world.add(Bullet.create(this));
		}
		
		override public function update():void {
			updatePosition();
			
			if (this.fireTrigger && this.fireTrigger()) {
				fireWait += FP.elapsed;
				if (fireWait > fireRate) {
					fireWait -= fireRate;
					this.fire();					
				}	
			} else if (this.releaseTrigger && this.releaseTrigger()) {
				fireWait = fireRate;
			}
		}
		
		public function updatePosition() {
			this.x = owner.x + relativeX;
			this.y = owner.y + relativeY;
		}
		
		public function destroy():void {
			pool(this);
		}
		
		private static var weaponPool:Array = [];
		
		public static function create(owner:Entity, relativeX:Number, relativeY:Number):Weapon {
			if (weaponPool.length == 0) {
				return new Weapon(owner, relativeX, relativeY);
			} else {
				var weapon:Weapon = weaponPool.pop() as Weapon;
				weapon.init(owner, relativeX, relativeY);
				return weapon;
			}
		}
		
		public static function pool(weapon:Weapon):void {
			weapon.world.remove(weapon);
			weapon.owner = null;
			weapon.fireTrigger = null;
			weapon.releaseTrigger = null;
			weaponPool.push(weapon);
		}
	}
}
