package  
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		/*[Embed(source = "../bin/data/music.mp3")] protected var BgMusic:Class;
		[Embed(source = "../bin/data/chase_music.mp3")] protected var ChaseMusic:Class;
		[Embed(source = "../bin/data/win_music.mp3")] protected var WinMusic:Class;*/
		
		//Model
		private var player:Player;
		private var level:Map;
		private var enemies:FlxGroup;
		private var enemy:Enemy;
		private var exit:FlxSprite;
		private var light:Light;
		//private var flashlight:FlashLight;
		private var darkness:FlxSprite;
		private var lightning:Lightning;
		
		
		//Controllers
		private var controllers:GameControllers;
		
		//Music controller
		private var musicController:MusicController;
		
		
		
		//TODO:  Erase these comments
		/*private var chaseMusic:FlxSound;
		private var chaseMusicOn:Boolean = false;*/
		
		//Timer
		//Moved it to enemy controller but may put a timer back here to control frame rate.
		//private var runTimer:Number = 0;
		//private var enemyTwo:Enemy;
		
		
		//TODO:  Any abstraction for lights + darkness?  (To localize rendering code)
		
		override public function create():void
		{

			
			/*chaseMusic = new FlxSound();
			chaseMusic.loadEmbedded(ChaseMusic, true);
			FlxG.playMusic(BgMusic);*/
			FlxG.bgColor = 0xffC9C9C9;
			
			//Create player, map, enemies, exit, darkness, lights, and respective controllers
			
						
			level = new Map(18,14,true);
			//level = new Map(0, 0, false);
			
			var playerStart:FlxPoint = Utils.tilePtToMidpoint(level, level.getStartTile());
			player = new Player(playerStart.x, playerStart.y);
			
			enemies = new FlxGroup();
			var enemyStart:FlxPoint = Utils.tilePtToMidpoint(level, level.getEndTile());
			//spawnEnemy(enemyStart.x, enemyStart.y);

			spawnEnemy(level.deadEnds[level.deadEnds.length - 2].y * 24, level.deadEnds[level.deadEnds.length - 2].x * 24);
			
			loadDarkness();
			loadLights();
			add(level);
			add(player);			
			add(enemies);

			
			loadExit();

			
			//enemyTwo = new Enemy(14, 210);
			//add(enemyTwo);
			
			
			controllers = new GameControllers();
			musicController = new MusicController(player, enemy, exit);

			add(controllers);
			//TODO:  Have a controller?
			//controllers.add(player.getController());
			controllers.add(enemy.getController());
			controllers.add(light.getController());
			//controllers.add(flashlight.getController());
			controllers.add(musicController);
			add(darkness);
			lightning = new Lightning(darkness, player, enemy);
			add(lightning);
		}
		
		override public function update():void
		{
			//TODO  Put this somewhere else
			if (FlxG.keys.ENTER)
			{
				FlxG.resetState();
			}
			super.update();
			
			//Collision Resolution
			FlxG.collide(player, level);
		}
		
		override public function draw():void
		{
			super.draw();
		}
		
		private function spawnEnemy(x:Number, y:Number):void
		{
			enemy = new Enemy(x, y,this.player, level);
			enemies.add(enemy);
			
		}
		
		private function loadExit():void
		{
			//not sure this is working.
			var currentExitPoint:FlxPoint = level.deadEnds[0];
			var currentDistance:Number = Utils.getPathDistance(level.findPath(player.getMidpoint(), currentExitPoint));
			for (var i:int = 0; i++; i < level.deadEnds.length)
			{
				var distance:Number = Utils.getPathDistance(level.findPath(player.getMidpoint(), level.deadEnds[i]));
				if (distance > currentDistance)
				{
					currentDistance = distance;
					currentExitPoint = level.deadEnds[i];
				}
			}
			
			exit = new FlxSprite(currentExitPoint.y * 24 + 5, currentExitPoint.x * 24 + 3, null);
			exit.makeGraphic(12, 16, 0xff8B8682);
			add(exit);
		}
		
		private function loadDarkness():void
		{
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
		}
		
		private function loadLights():void
		{
			light = new Light(12, 12, darkness, player);
			var lightSize:FlxPoint = new FlxPoint(1, 1);
			light.scale = lightSize;
			add(light);
			//flashlight = new FlashLight(12, 12, darkness, player);
			//var lightSize:FlxPoint = new FlxPoint(1, 1);
			//light.scale = lightSize;
			//add(flashlight);
		}
	}

}
