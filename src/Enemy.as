package  
{
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite
	{
		//[Embed(source = "../bin/data/Enemy.png")] protected var ImgEnemy:Class;
		public var controller:EnemyController;
		private var enemyRunSpeed:Number;
		private var hallucination:Boolean;
		public function Enemy(x:Number, y:Number, player:Player, level:Map, hallucination:Boolean) 
		{
			super(0, 0, null);
			super.x = x;
			super.y = y;
			this.enemyRunSpeed = 50;
			this.hallucination = hallucination;
			loadEnemy();
			this.controller = new EnemyController(this, player, level, enemyRunSpeed);
			
			width = 1;
			height = 1;
			offset.x = 10;
			offset.y = 10;
		}
		
		private function loadEnemy():void
		{
			//loadGraphic(ImgEnemy, true, true, 15, 14);
			makeGraphic(18, 18, 0xff000000);
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
		
		public function isHallucination():Boolean {
			return this.hallucination;
		}
	}

}