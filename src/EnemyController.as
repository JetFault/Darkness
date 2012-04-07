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
		
		[Embed(source = "../bin/data/whispersSound.mp3")] protected var SirenSound:Class;
		
		private var enemyStep1:FlxSound;
		private var enemyStep2:FlxSound;
		private var enemyStep3:FlxSound;
		
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
		
		public function EnemyController(enemy:Enemy, player:Player, level:Map, enemyRunSpeed:Number, enemyType:uint) 
		{
			enemyStep1 = FlxG.loadSound(EnemyStepSound1);
			enemyStep2 = FlxG.loadSound(EnemyStepSound2);
			enemyStep3 = FlxG.loadSound(EnemyStepSound3);
			
			sirenSound = FlxG.loadSound(SirenSound);
			
			this.player = player;
			this.enemy = enemy;
			this.level = level;
			this.enemyRunSpeed = enemyRunSpeed;
			this.runTimer = 0;
			if(enemyType == EnemyType.DFS_PATHER){
				this.ai = new DFSSearchAI(enemy, player, level);
			}else if (enemyType == EnemyType.UCS_PATHER) {
				this.ai = new UCSSearchAI(enemy, player, level);
			}else if (enemyType == EnemyType.DO_NOTHING) {
				this.ai = new DoNothingAI(enemy, player, level);
			}
			
			prePosition = enemy.getMidpoint();
		}
		
		override public function update():void {
			//enemyStep1.update();
			//enemyStep2.update();
			//enemyStep3.update();
			//sirenSound.update();
			
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
			
			var distance:Number = Utils.getDistance(playerPos, enemyPos);
			
			var maxDis:Number = 150;
			var m:Number = -1 / maxDis;
			var b:Number = 1;
			var x:Number = distance;
			var y:Number = (m * x) + b;
			var shake:Number;
			if (y > 0) {
				shake = y;
			} else {
				shake = 0;
			}
			var Volume:Number = y;
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
			prePosition = enemy.getMidpoint();
			//End FootSteps---
			
			//SIREN---
			if (ai.visible) {
				sirenSound.play();
			} else {
				sirenSound.stop();
			}
			//End SIREN---
			ai.doNextAction();
			
			//Time since last iteration
			runTimer += FlxG.elapsed;
			
			
			/*
			if (runTimer > 3 && enemy.getEnemyRunSpeed() < maxRunSpeed)
			{
				enemy.incrementEnemyRunSpeed(enemy.getEnemyRunSpeed()*.2);
				runTimer = 0;
			}
			*/
			
			/*var velocityp:FlxPoint = new FlxPoint(enemy.velocity.x, enemy.velocity.y);
			var origin:FlxPoint = new FlxPoint(0, 0);
			enemy.angle = FlxU.getAngle(origin, velocityp);*/
			
			super.update();
		}
		
		override public function destroy(): void {
			if (sirenSound.active) {
				sirenSound.stop();
			}
			super.destroy();
		}
	}

}