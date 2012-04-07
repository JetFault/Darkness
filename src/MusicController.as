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
		[Embed(source = "../bin/data/RainSound1-1.mp3")] protected var RainMusic:Class;
		[Embed(source = "../bin/data/WindSound.mp3")] protected var WindMusic:Class;
		
		private var chaseMusic:FlxSound;
		private var chaseMusicOn:Boolean = false;
		
		private var rainMusic:FlxSound;
		private var windMusic:FlxSound;
		
		private var player:Player;
		private var enemy:Enemy;
		private var exit:FlxSprite;
		
		
		public function MusicController(player:Player, enemy:Enemy, exit:FlxSprite) 
		{
			chaseMusic = FlxG.loadSound(ChaseMusic, 0, true);
			
			rainMusic =FlxG.loadSound(RainMusic, 0.04, true);
			rainMusic.play();
			
			windMusic = FlxG.loadSound(WindMusic, .06, true);
			windMusic.play();
			
			this.player = player;
			this.enemy = enemy;
			this.exit = exit;
			//FlxG.playMusic(BgMusic);
			
			super();
			
		}
		
		override public function update():void {
			//chaseMusic.update();
			var playerPos:FlxPoint = player.getMidpoint();
			var enemyPos:FlxPoint = enemy.getMidpoint();
			
			
			//TODO:  Get collision detection out of here.
			var distance:Number = Utils.getDistance(playerPos, enemyPos);
			
			//if (distance <= 80) {
				//chaseMusic.proximity(enemyPos.x, enemyPos.y, player,80);
			//}
			if (distance > 80)
			{
				chaseMusic.volume = 0;
			}else if (distance <= 80 && distance > 70) {
				chaseMusic.volume = .02;
			}else if (distance <= 70 && distance > 65) {
				chaseMusic.volume = .05;
			}else if (distance <= 65 && distance > 60) {
				chaseMusic.volume = .08;
			}else if (distance <= 60 && distance > 55) {
				chaseMusic.volume = .10;
			}else if (distance <= 55 && distance > 50) {
				chaseMusic.volume = .15;
			}else if (distance <= 50 && distance > 40) {
				chaseMusic.volume = .25;
			}else if (distance <= 40 && distance > 30) {
				chaseMusic.volume = .50;
			}else if (distance <= 30) { // && distance > 20
				chaseMusic.volume = .85;
			}
			
			
			
			super.update();
		}
		
		
		
		
		override public function destroy(): void {
			if (chaseMusic.active) {
				//chaseMusic.stop();
			}
			super.destroy();
		}
	}
	
	
		

}