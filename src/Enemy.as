package  
{
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite
	{
		//[Embed(source = "../bin/data/Enemy.png")] protected var ImgEnemy:Class;
		[Embed(source = "../bin/data/EnemyAnimation4.png")] protected var ImgEnemy:Class;
		
		public var controller:EnemyController;
		private var enemyRunSpeed:Number;
		private var hallucination:Boolean;
		private var enemyType:uint;
		public var hitbox:FlxSprite;
		public function Enemy(x:Number, y:Number, player:Player, level:Map, hallucination:Boolean, enemyType:uint) 
		{
			super(0, 0, null);
			super.x = x;
			super.y = y;
			this.hitbox = new FlxSprite(this.getMidpoint().x, this.getMidpoint().y);

			hitbox.makeGraphic(1, 1, 0xff000000);

			hitbox.makeGraphic(9, 9, 0x00ff0000);

			hitbox.x = this.getMidpoint().x - hitbox.width / 2;
			hitbox.y = this.getMidpoint().y - hitbox.height / 2;
			this.enemyRunSpeed = 50;
			this.hallucination = hallucination;
			loadEnemy();
			if (this.hallucination) {
				this.controller = new EnemyController(this, player, level, enemyRunSpeed, EnemyType.DO_NOTHING);
			}else{
				this.controller = new EnemyController(this, player, level, enemyRunSpeed, enemyType);
			}
			this.enemyType = enemyType;
			//Deliberately commented these out.  Try something else...
			//width = 1;
			//height = 1;
			//offset.x = 10;
			//offset.y = 10;
			addAnimation("raged", [0, 1, 2], 10);//30
			addAnimation("walk", [3, 4, 5, 4], 2);//30
			play("walk");
		}
		
		private function loadEnemy():void
		{
			loadGraphic(ImgEnemy, true, true, 32, 33);
			//makeGraphic(18, 18, 0xff000000);
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
		
		public function getHitbox():FlxSprite {
			return this.hitbox;
		}
		
	}

}