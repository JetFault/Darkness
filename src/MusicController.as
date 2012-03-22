package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class MusicController extends BaseController
	{
		
		[Embed(source = "../bin/data/music.mp3")] protected var BgMusic:Class;
		[Embed(source = "../bin/data/chase_music.mp3")] protected var ChaseMusic:Class;
		[Embed(source = "../bin/data/win_music.mp3")] protected var WinMusic:Class;
		
		private var chaseMusic:FlxSound;
		private var chaseMusicOn:Boolean = false;
		private var player:Player;
		private var enemy:Enemy;
		private var exit:FlxSprite;
		
		
		public function MusicController(player:Player, enemy:Enemy, exit:FlxSprite) 
		{
			chaseMusic = new FlxSound();
			chaseMusic.loadEmbedded(ChaseMusic, true);
			this.player = player;
			this.enemy = enemy;
			this.exit = exit;
			FlxG.playMusic(BgMusic);
			
			super();
			
		}
		
		override public function update():void {
			chaseMusic.update();
			var playerPos:FlxPoint = player.getMidpoint();
			var enemyPos:FlxPoint = enemy.getMidpoint();
			
			
			//TODO:  Get collision detection out of here.
			
			if (getEnemyDistance(playerPos, enemyPos) < 60)
			{
				if (!chaseMusicOn)
				{
					chaseMusic.fadeIn(5);
					chaseMusicOn = true;
				}
			}
			
			if (getEnemyDistance(playerPos, enemyPos) > 60 && chaseMusicOn)
			{
				chaseMusic.fadeOut(3);
				chaseMusicOn = false;
			}
			if (FlxG.overlap(player, enemy))
			{
				FlxG.shake();
				player.kill();
				chaseMusic.fadeOut(3);
			}
			
			if (FlxG.overlap(player, exit))
			{
				player.kill();
				enemy.kill();
				chaseMusic.stop();
				FlxG.music.stop();
				FlxG.playMusic(WinMusic);
			}
			
			super.update();
		}
		
		
		private function getEnemyDistance(playerPos:FlxPoint, enemyPos:FlxPoint):Number
		{
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}
		
		override public function destroy(): void {
			if (chaseMusic.active) {
				chaseMusic.stop();
			}
			super.destroy();
		}
	}
	
	
		

}