package  
{
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite
	{
		//[Embed(source = "../bin/data/Enemy.png")] protected var ImgEnemy:Class;
		[Embed(source = "../bin/data/EnemyAnimation4.png")] protected var ImgEnemy:Class;
		[Embed(source = "../bin/data/EnemyEyeAnimation.png")] protected var ImgEye:Class;
		
		public var controller:EnemyController;
		private var enemyRunSpeed:Number;
		private var hallucination:Boolean;
		private var enemyType:uint;
		public var hitbox:FlxSprite;
		private var eyeSprite:FlxSprite;
		
		public function Enemy(x:Number, y:Number, player:Player, level:Map, hallucination:Boolean, enemyType:uint, onpathcompletion:String) 
		{
			super(0, 0, null);
			super.x = x;
			super.y = y;
			//Make hitbox
			this.hitbox = new FlxSprite(this.getMidpoint().x, this.getMidpoint().y);
			hitbox.makeGraphic(6, 6, 0xffff0000);
			hitbox.x = this.getMidpoint().x - hitbox.width / 2;
			hitbox.y = this.getMidpoint().y - hitbox.height / 2;
			this.eyeSprite = new FlxSprite(0, 0, null);
			
			this.enemyRunSpeed = 44;
			loadEnemy();
			//Hallucination code
			this.hallucination = hallucination;
			if (this.hallucination) {
				this.controller = new EnemyController(this, player, level, enemyRunSpeed, EnemyType.DO_NOTHING, onpathcompletion);
			}else{
				this.controller = new EnemyController(this, player, level, enemyRunSpeed, enemyType, onpathcompletion);
			}
			this.enemyType = enemyType;
			//Add animations
			addAnimation("raged", [0, 1, 2], 10);//30
			addAnimation("walk", [3, 4, 5, 4], 2);//30
			this.eyeSprite.addAnimation("raged", [0, 1, 2], 10);//30
			this.eyeSprite.addAnimation("walk", [3, 4, 5, 4], 2);//30
			play("walk");
			
			//if (this.hallucination) {
			//	this.hitbox.y -= 10;
			//	this.y -= 10;
			//}
		}
		
		private function loadEnemy():void
		{
			loadGraphic(ImgEnemy, true, true, 32, 33);
			this.eyeSprite.loadGraphic(ImgEye, true, true, 32, 33);
			//makeGraphic(15, 15, 0xff000000);
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
		
		public function getEyeSprite():FlxSprite {
			return this.eyeSprite;
		}
		
	}

}