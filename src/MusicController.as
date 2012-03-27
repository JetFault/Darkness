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
			chaseMusic.play();
			chaseMusic.volume = 0;
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
			var distance:Number = Utils.getDistance(playerPos, enemyPos);
			
			if (distance < 80 && distance > 70) {
				chaseMusic.volume = .02;
			}
			if (distance < 70 && distance > 65) {
				chaseMusic.volume = .05;
			}
			if (distance < 65 && distance > 60) {
				chaseMusic.volume = .08;
			}
			if (distance < 60 && distance > 55) {
				chaseMusic.volume = .10;
			}
			if (distance < 55 && distance > 50) {
				chaseMusic.volume = .15;
			}
			if (distance < 50 && distance > 40) {
				chaseMusic.volume = .25;
			}
			if (distance < 40 && distance > 30) {
				chaseMusic.volume = .50;
			}
			if (distance < 30 && distance > 20) {
				chaseMusic.volume = .85;
			}
			/*
			switch(distance)
			{
				case 60:
					chaseMusic.volume = .10;
					break;
				case 55:
					chaseMusic.volume = .15;
					break;
				case 50:
					chaseMusic.volume = .25;
					break;
				case 45:
					chaseMusic.volume = .35;
					break;
				case 40:
					chaseMusic.volume = .45;
					break;
				case 30:
					chaseMusic.volume = .65;
					break;
				case 20:
					chaseMusic.volume = 1;
					break;
					
			}
			*/
			
			if (distance > 80)
			{
				chaseMusic.volume = 0;
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
		
		
		
		
		override public function destroy(): void {
			if (chaseMusic.active) {
				chaseMusic.stop();
			}
			super.destroy();
		}
	}
	
	
		

}