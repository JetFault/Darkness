package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	import org.flixel.*;
	public class EnemyController extends BaseController
	{
		[Embed(source = "../bin/data/EnemyStep1.mp3")] protected var EnemyStepSound1:Class;
		[Embed(source = "../bin/data/EnemyStep2.mp3")] protected var EnemyStepSound2:Class;
		[Embed(source = "../bin/data/EnemyStep3.mp3")] protected var EnemyStepSound3:Class;
		[Embed(source = "../bin/data/HighStatic.mp3")] protected var HighStaticSound:Class;
		[Embed(source = "../bin/data/whispersSound.mp3")] protected var SirenSound:Class;
		
		private var enemyStep1:FlxSound;
		private var enemyStep2:FlxSound;
		private var enemyStep3:FlxSound;
		private var highStaticSound:FlxSound;
		private var sirenSound:FlxSound;
		private var stepPlayed:Number;
		
		
		private var player:Player;
		private var enemy:Enemy;
		private var level:Map;
		private var enemyRunSpeed:Number;
		private var maxRunSpeed:Number = 100;
		private var runTimer:Number;
		private var ai:EnemyAI;
		
		private var runSpeed:Number = 35;
		private var walkSpeed:Number = 15;
		
		private var stepDis:Number = 0;
		private var stepLength:Number = 40;
		//private var walkLength:Number = 60;
		//private var runLength:Number = 30;
		private var prePosition:FlxPoint;
		
		public function EnemyController(enemy:Enemy, player:Player, level:Map, enemyRunSpeed:Number, enemyType:uint, onpathcompletion:String, depth:Number) 
		{
			//load sounds
			enemyStep1 = FlxG.loadSound(EnemyStepSound1);
			enemyStep2 = FlxG.loadSound(EnemyStepSound2);
			enemyStep3 = FlxG.loadSound(EnemyStepSound3);
			sirenSound = FlxG.loadSound(SirenSound);
			highStaticSound = FlxG.loadSound(HighStaticSound);
			
			
			this.player = player;
			this.enemy = enemy;
			this.level = level;
			this.enemyRunSpeed = enemyRunSpeed;
			this.runTimer = 0;
			if(enemyType == EnemyType.DFS_PATHER){
				this.ai = new DFSSearchAI(enemy, player, level, onpathcompletion, depth);
			}else if (enemyType == EnemyType.UCS_PATHER) {
				this.ai = new UCSSearchAI(enemy, player, level, onpathcompletion, depth);
			}else if (enemyType == EnemyType.DO_NOTHING) {
				this.ai = new DoNothingAI(enemy, player, level, onpathcompletion, depth);
			}else if (enemyType == EnemyType.RANDOM_DFS) {
				this.ai = new RandomDFSAI(enemy, player, level, onpathcompletion, depth);
			}
			
			prePosition = enemy.getMidpoint();
		}
		
		override public function update():void {
			
			//Cleanup after hallucination died
			if (!this.enemy.alive) {
				this.destroy();
				return;
			}
			
			
			var playerPos:FlxPoint = player.getMidpoint();
			var enemyPos:FlxPoint = enemy.getMidpoint();
			//TODO:  Get collision detection out of here.
			//FootSteps---
			/*
			if (visible) {
				stepLength = runLength;
			} else {
				stepLength = walkLength;
			}
			*/
			/*
			var distance:Number = Utils.getDistance(playerPos, enemyPos);
			
			var maxDis:Number = 150;
			var m:Number = -1 / maxDis;
			var b:Number = 1;
			var x:Number = distance;
			var y:Number = (m * x) + b;
			*/
			highStaticSound.volume = Utils.getVolume(40, playerPos, enemyPos);
			highStaticSound.play();
			
			var Volume:Number = Utils.getVolume(100, playerPos, enemyPos);
			var shake:Number;
			if (Volume > 0) {
				shake = Volume;
			} else {
				shake = 0;
			}
			enemyStep1.volume = Volume;
			enemyStep2.volume = Volume;
			enemyStep3.volume = Volume;
			sirenSound.volume = Volume;
			
			stepDis += Utils.getDistance(prePosition, enemy.getMidpoint());
			if (stepDis >= stepLength) {
				var rand:Number = Math.random();
				if (rand < (1/3)) 			{	enemyStep1.play(true); }
				else if (rand < (2/3)) 		{	enemyStep2.play(true); }
				else 						{	enemyStep3.play(true); }
				FlxG.shake(0.02 * shake, 0.2 * shake, null, true, 0);
				stepDis = 0;
			}
			prePosition = enemyPos;
			//End FootSteps---
			
			//SIREN---
			if (ai.visible) {
				sirenSound.play();
				enemy.play("raged");
				enemy.getEyeSprite().play("raged");
			/*} else if (Utils.getDistance(playerPos, enemyPos) < 50) {
				sirenSound.play();
				enemy.play("raged");*/
			} else {
				sirenSound.stop();
				enemy.play("walk");
				enemy.getEyeSprite().play("walk");
			}
			//End SIREN---
			ai.doNextAction();
			
			
			
			//Time since last iteration
			//runTimer += FlxG.elapsed;
			/*
			if (runTimer > 3 && enemy.getEnemyRunSpeed() < maxRunSpeed)
			{
				enemy.incrementEnemyRunSpeed(enemy.getEnemyRunSpeed()*.2);
				runTimer = 0;
			}
			*/
			
			var thespritethatmatters:FlxSprite = enemy.getHitbox();
			var theothersprite:FlxSprite = enemy;
			
			var velocityp:FlxPoint = new FlxPoint(thespritethatmatters.velocity.x, thespritethatmatters.velocity.y);
			var origin:FlxPoint = new FlxPoint(0, 0);
			theothersprite.angle = FlxU.getAngle(origin, velocityp);
			//----FUCKING SPASTIC------
			if (ai.visible) 
			{ 
				theothersprite.angle += (Math.random() - 0.5) * 110;	
			}
			//else if (Utils.getDistance(playerPos, enemyPos) < 50) {
			//	enemy.angle += (Math.random() - 0.5) * 110;	
			//
			//}
			//----END OF SPASTIC-----
			//enemy.hitbox.x = enemy.getMidpoint().x - enemy.hitbox.width / 2;
			//enemy.hitbox.y = enemy.getMidpoint().y - enemy.hitbox.width / 2;
			
			theothersprite.x = thespritethatmatters.getMidpoint().x - theothersprite.width / 2;
			theothersprite.y = thespritethatmatters.getMidpoint().y - theothersprite.height / 2;
			enemy.getEyeSprite().x = enemy.x;
			enemy.getEyeSprite().y = enemy.y;
			enemy.getEyeSprite().angle = enemy.angle;
			super.update();
		}
		
		override public function destroy(): void {
			if (sirenSound.active) {
				sirenSound.stop();
			}
			super.destroy();
		}
		
		public function setPlayerVisible(): void {
			this.ai.setPlayerVisible();
		}
	}

}