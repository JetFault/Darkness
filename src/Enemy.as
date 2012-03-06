package  
{
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite
	{
		public var controller:EnemyController;
		private var enemyRunSpeed:Number;
		public function Enemy(x:Number, y:Number, player:Player, level:Map) 
		{
			super(0, 0, null);
			super.x = x;
			super.y = y;
			this.enemyRunSpeed = 10;
			loadEnemy();
			this.controller = new EnemyController(this, player, level, enemyRunSpeed);
		}
		
		private function loadEnemy():void
		{
			makeGraphic(10, 10, 0xffCD0000);
		}
		
		public function getEnemyRunSpeed():Number {
			return this.enemyRunSpeed;
		}
		
		public function incrementEnemyRunSpeed(incrementby:Number):void {
			this.enemyRunSpeed += incrementby;
		}
		
		public function getController():BaseController {
			return this.controller;
		}
	}

}