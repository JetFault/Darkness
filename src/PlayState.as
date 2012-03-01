package  
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source = "../bin/data/music.mp3")] protected var BgMusic:Class;
		[Embed(source = "../bin/data/chase_music.mp3")] protected var ChaseMusic:Class;
		[Embed(source = "../bin/data/win_music.mp3")] protected var WinMusic:Class;
		private var player:Player;
		private var level:Map;
		private var enemies:FlxGroup;
		private var enemy:Enemy;
		private var enemyRunSpeed:Number = 10;
		private var chaseMusic:FlxSound;
		private var chaseMusicOn:Boolean = false;
		private var exit:FlxSprite;
		private var light:Light;
		private var darkness:FlxSprite;
		private var playerAlive:Boolean = true;
		private var runTimer:Number = 0;
		private var enemyTwo:Enemy;
		
		override public function create():void
		{
			chaseMusic = new FlxSound();
			chaseMusic.loadEmbedded(ChaseMusic, true);
			FlxG.playMusic(BgMusic);
			FlxG.bgColor = 0xffC9C9C9;
			
			player = new Player(12, 12);
			level = new Map();
			add(level);
			add(player);
			
			enemies = new FlxGroup();
			add(enemies);
			
			loadExit();
			loadDarkness();
			loadLights();
			
			spawnEnemy(234, 12);
			//enemyTwo = new Enemy(14, 210);
			//add(enemyTwo);
			add(darkness);
		}
		
		override public function update():void
		{
			runTimer += FlxG.elapsed;
			var enemyPath:FlxPath = level.findPath(enemy.getMidpoint(), player.getMidpoint());
			enemy.followPath(enemyPath, enemyRunSpeed);
			//enemyTwo.followPath(level.findPath(enemyTwo.getMidpoint(), player.getMidpoint()), enemyRunSpeed);
			light.x = player.x + 4;
			light.y = player.y + 5;
			var playerPos:FlxPoint = player.getMidpoint();
			var enemyPos:FlxPoint = enemy.getMidpoint();
			//var enemy2Pos:FlxPoint = enemyTwo.getMidpoint();
			
			if (FlxG.keys.ENTER && !playerAlive)
			{
				FlxG.resetState();
			}
			super.update();
			FlxG.collide(player, level);
			chaseMusic.update();
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
				playerAlive = false;
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
			
			if (runTimer > 3 && enemyRunSpeed < 50)
			{
				enemyRunSpeed += enemyRunSpeed * .20;
				runTimer = 0;
			}
		}
		
		override public function draw():void
		{
			darkness.fill(0xff000000);
			super.draw();
		}
		
		private function spawnEnemy(x:Number, y:Number):void
		{
			enemy = new Enemy(x, y);
			enemies.add(enemy);
			
		}
		
		private function getEnemyDistance(playerPos:FlxPoint, enemyPos:FlxPoint):Number
		{
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}
		
		private function loadExit():void
		{
			exit = new FlxSprite(298, 155, null);
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
			light = new Light(12, 12, darkness);
			var lightSize:FlxPoint = new FlxPoint(1, 1);
			light.scale = lightSize;
			add(light);
		}
	}

}