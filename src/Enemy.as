package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Enemy extends FlxSprite
	{
		//[Embed(source = "../bin/data/Enemy.png")] protected var ImgEnemy:Class;
		[Embed(source = "../bin/data/EnemyAnimation4.png")] protected var ImgEnemy:Class;
		[Embed(source = "../bin/data/EnemyEyeAnimation.png")] protected var ImgEye:Class;
		[Embed(source = "../bin/data/EnemyAnimationGreen.png")] protected var ImgEnemyGreen:Class;
		[Embed(source = "../bin/data/EnemyEyeAnimationGreen.png")] protected var ImgEyeGreen:Class;
		
		public var controller:EnemyController;
		private var enemyRunSpeed:Number;
		private var hallucination:Boolean;
		private var enemyType:uint;
		public var hitbox:FlxSprite;
		private var eyeSprite:FlxSprite;
		private var originalposition:FlxPoint;
		
		public function Enemy(x:Number, y:Number, player:Player, level:Map, hallucination:Boolean, enemyType:uint, onpathcompletion:String, depth:Number = 5) 
		{
			super(0, 0, null);
			super.x = x;
			super.y = y;
			this.enemyType = enemyType;
			//Make hitbox
			this.hitbox = new FlxSprite(this.getMidpoint().x, this.getMidpoint().y);
			hitbox.makeGraphic(6, 6, 0x00ff0000);
			hitbox.x = this.getMidpoint().x - hitbox.width / 2;
			hitbox.y = this.getMidpoint().y - hitbox.height / 2;
			originalposition = new FlxPoint(hitbox.getMidpoint().x, hitbox.getMidpoint().y);

			this.eyeSprite = new FlxSprite(0, 0, null);
			
			this.enemyRunSpeed = 44;
			
			if (this.enemyType == EnemyType.UCS_PATHER) {
				this.enemyRunSpeed = 35;
			}
			loadEnemy();
			//Hallucination code
			this.hallucination = hallucination;
			if (this.hallucination) {
				this.controller = new EnemyController(this, player, level, enemyRunSpeed, EnemyType.DO_NOTHING, onpathcompletion, depth);
			}else{
				this.controller = new EnemyController(this, player, level, enemyRunSpeed, enemyType, onpathcompletion, depth);
			}
			
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
			if(this.enemyType != EnemyType.UCS_PATHER){
				loadGraphic(ImgEnemy, true, true, 32, 33);
				this.eyeSprite.loadGraphic(ImgEye, true, true, 32, 33);
			}else {
				loadGraphic(ImgEnemyGreen, true, true, 32, 33);
				this.eyeSprite.loadGraphic(ImgEyeGreen, true, true, 32, 33);
			}
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
		
		public function getOriginalPosition():FlxPoint {
			return this.originalposition
		}
		
		
		public function dance():void {
			this.controller.dance();
		}
		
	}

}