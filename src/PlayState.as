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
			controllers = new GameControllers();
			
			/*chaseMusic = new FlxSound();
			chaseMusic.loadEmbedded(ChaseMusic, true);
			FlxG.playMusic(BgMusic);*/
			FlxG.bgColor = 0xffC9C9C9;
			
			//Create player, map, enemies, exit, darkness, lights, and respective controllers
			
						
			level = new Map(33,25,true);
			//level = new Map(10, 10, true);

			//level = new Map();
			
			loadDarkness();
			loadLights();
			add(level);
			add(player);
			enemies = new FlxGroup();
			add(enemies);

			
			loadExit();

			 
			spawnEnemy(234, 12);
			
			
			//enemyTwo = new Enemy(14, 210);
			//add(enemyTwo);
			
			musicController = new MusicController(player, enemy, exit);

			add(controllers);
		//	controllers.add(player.getController());
		//	controllers.add(enemy.getController());
		//	controllers.add(light.getController());
		//	controllers.add(flashlight.getController());
		//	controllers.add(musicController);
		//	add(darkness);
		}
		
		override public function update():void
		{
			//Time since last iteration
			//runTimer += FlxG.elapsed;
			
			//Replaces commented-out code below
			//TODO: Replace with iterator
			//enemy.controller.update();
			//light.controller.update();
			
			
			//var enemyPath:FlxPath = level.findPath(enemy.getMidpoint(), player.getMidpoint());
			//enemy.followPath(enemyPath, enemyRunSpeed);
			//enemyTwo.followPath(level.findPath(enemyTwo.getMidpoint(), player.getMidpoint()), enemyRunSpeed);
			//light.x = player.x + 4;
			//light.y = player.y + 5;
			
			
			
			
			//var enemy2Pos:FlxPoint = enemyTwo.getMidpoint();
			
			//TODO  Put this somewhere else
			if (FlxG.keys.ENTER)
			{
				FlxG.resetState();
			}
			
			
			super.update();
			
			//Collision Resolution
			FlxG.collide(player, level);
			
			
			
			//chaseMusic.update();
			
			
			
			/*var playerPos:FlxPoint = player.getMidpoint();
			var enemyPos:FlxPoint = enemy.getMidpoint();
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
			}*/
			
			/*if (runTimer > 3 && enemy.getEnemyRunSpeed() < 50)
			{
				enemy.incrementEnemyRunSpeed(enemy.getEnemyRunSpeed() * .20);
				runTimer = 0;
			}*/
		}
		
		override public function draw():void
		{
			if(darkness != null) {
				darkness.fill(0xff000000);
			}
			super.draw();
		}
		
		private function spawnEnemy(x:Number, y:Number):void
		{
			enemy = new Enemy(x, y,this.player, level);
			enemies.add(enemy);
			
		}
		
		/*private function getEnemyDistance(playerPos:FlxPoint, enemyPos:FlxPoint):Number
		{
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}*/
		
		private function loadExit():void
		{
			exit = new FlxSprite(12, 12, null);
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
