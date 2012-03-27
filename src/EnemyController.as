package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	import org.flixel.*;
	public class EnemyController extends BaseController
	{
		private var player:Player;
		private var enemy:Enemy;
		private var level:Map;
		private var enemyRunSpeed:Number;
		private var maxRunSpeed:Number = 100;
		private var runTimer:Number;
		private var ai:EnemyAI;
		
		public function EnemyController(enemy:Enemy, player:Player, level:Map, enemyRunSpeed:Number) 
		{
			this.player = player;
			this.enemy = enemy;
			this.level = level;
			this.enemyRunSpeed = enemyRunSpeed;
			this.runTimer = 0;
			this.ai = new DFSSearchAI(enemy, player, level);
		}
		
		override public function update():void {
			//Time since last iteration
			
			ai.doNextAction();
			//var enemyPath:FlxPath = level.findPath(enemy.getMidpoint(), player.getMidpoint());
			//enemy.followPath(enemyPath, enemy.getEnemyRunSpeed());
			
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
	}

}