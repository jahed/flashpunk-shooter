package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Spritemap;

	public class ShipEntity extends Entity {
		
		protected var speed:Number = 150;
		
		private var weapons:Array = [];

		public function ShipEntity() {
			
		}
		
		override public function added():void {
			//add weapons and other children
		}
		override public function removed():void {
			//remove weapons and other children
		}
		
		public function addWeapon(relativeX:Number, relativeY:Number, fireCondition:Function, releaseCondition:Function):void {
			var weapon:Weapon = this.world.create(Weapon) as Weapon;
			weapon.init(this, relativeX, relativeY);
			weapon.setFireCondition(fireCondition);
			weapon.setReleaseCondition(releaseCondition);
			
			weapons.push(weapon);
		}
		
		public function removeWeapon(weapon:Weapon):void {
			weapons.splice(weapons.indexOf(weapon), 1);
		}
		
		public function clearWeapons():void {
			weapons = [];
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
