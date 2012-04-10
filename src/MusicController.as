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
		[Embed(source = "../bin/data/RainSound1-2.mp3")] protected var RainMusic:Class;
		[Embed(source = "../bin/data/WindSound.mp3")] protected var WindMusic:Class;
		[Embed(source = "../bin/data/NormalStatic.mp3")] protected var StaticMusic:Class;
		[Embed(source = "../bin/data/LWHS-SoFarAway.mp3")] protected var GhostMusic:Class;//LWHS-SoFarAway LWHS-TheHauntOfYou
		
		private var rainMusic:FlxSound;
		private var windMusic:FlxSound;
		private var staticMusic:FlxSound;
		private var ghostMusic:FlxSound;
		
		private var player:Player;
		private var enemy:Enemy;
		private var exit:FlxSprite;
		
		private var timePassed:Number = 0;
		
		public function MusicController(player:Player, enemy:Enemy, exit:FlxSprite) 
		{
			rainMusic =FlxG.loadSound(RainMusic, 0.04, true);
			rainMusic.play();
			windMusic = FlxG.loadSound(WindMusic, .06, true);
			windMusic.play();
			staticMusic = FlxG.loadSound(StaticMusic, .01, true);
			staticMusic.play();
			ghostMusic = FlxG.loadSound(GhostMusic, .03, true);
			ghostMusic.play();
			
			
			this.player = player;
			this.enemy = enemy;
			this.exit = exit;
			
			super();
		}
		
		override public function update():void {
			timePassed += FlxG.elapsed;
			rainMusic.volume = 0.04 + (Math.sin(timePassed * 0.10) * 0.025); //2
			windMusic.volume = 0.06 + (Math.sin(timePassed * 0.15) * 0.025); //3
			staticMusic.volume=0.03 + (Math.sin(timePassed * 0.25) * 0.01);  //5
			
			
			
			super.update();
		}
		
		
		
		
		override public function destroy(): void {
			super.destroy();
		}
	}
	
	
		

}