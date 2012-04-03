package  
{
	import flash.events.WeakFunctionClosure;
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

			//spawnEnemy(level);
			
			//loadDarkness();
//			loadLights(level);

			add(level);
			add(player);			
			//add(enemies);

			colorDeadEnds();
			
			//loadExit(level);
			
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			FlxG.camera.follow(player);

			
			//enemyTwo = new Enemy(14, 210);
			//add(enemyTwo);
			
			
			controllers = new GameControllers();
			musicController = new MusicController(player, enemy, exit);

			add(controllers);
			//TODO:  Have a controller?
			controllers.add(player.getController());
//			controllers.add(enemy.getController());
//			controllers.add(light.getController());
//			controllers.add(flashlight.getController());
//			controllers.add(musicController);
			add(darkness);
			lightning = new Lightning(darkness, player, enemy);
//			add(lightning);
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
		
		private function colorDeadEnds():void {
			for each(var deadEnd:FlxPoint in this.level.deadEnds) {
				var x:uint = deadEnd.x * this.level.getTileWidthInPixels();
				var y:uint = deadEnd.y * this.level.getTileHeightInPixels();
				
				var sprite:FlxSprite = new FlxSprite(x, y, null);
				sprite.makeGraphic(10, 10, 0xff8B8682);
				add(sprite);
			}
		}
		
		
		private function spawnEnemy(level:Map):void
		{
			var xlocPix:uint = 0;
			var ylocPix:uint = 0;
			
			var found:Boolean = false;
			for (var i:uint = 0; i < level.deadEnds.length; i++) {
				var dead:FlxPoint = level.deadEnds[i];
				var xlocMaze:uint = dead.x;
				var ylocMaze:uint = dead.y;
				
				if ( (xlocMaze >= level.getMaze().getWidth() / 2) 
					&& (ylocMaze >= level.getMaze().getHeight() / 2)
					&& (xlocMaze < level.getMaze().getWidth())
					&& (ylocMaze < level.getMaze().getHeight()) ) {
						
					
						found = true;
						xlocPix = level.getTileWidthInPixels() * xlocMaze;
						ylocPix = level.getTileHeightInPixels() * ylocMaze;
						break;
				}			
			}
			
			//Couldn't find any dead ends
			if (!found) {
				
				trace("No dead ends!");
				
				var end:FlxPoint = findValidLocation(level);
				if (end == null) {
					trace("NULL!");
				}
				xlocPix = end.x;
				ylocPix = end.y;
			}
					
			trace("xloc", xlocPix);
			trace("yloc", ylocPix);
			
			enemy = new Enemy(xlocPix, ylocPix, this.player, level);
			enemies.add(enemy);
			
		}
		
		private function findValidLocation(level:Map):FlxPoint {
			var maze:Array = level.getMaze().getMazeArray();
			var height:uint = level.getMaze().getHeight();
			var width:uint = level.getMaze().getWidth();
			
			var end:FlxPoint;
			
			for (var j:uint = 0; j < height; j++) {
				//This is why you don't program tired
				for (var i:uint = width - 1; (i >= width - j) && (i >=0) && (i < width); i--) {
					if (!level.isWall(j, i)) {
						trace("j:", j);
						trace("i:", i);
						end = new FlxPoint(j*level.getTileHeightInPixels(), i*level.getTileWidthInPixels());
						if (isPath(level, end, this.player.getMidpoint())) {
							return end;
						}
					}
					
				}
			}
			return null;
		}
		
		private function isPath(level:Map, point1:FlxPoint, point2:FlxPoint):Boolean {
			if ( level.findPath(point1, point2, true, false) != null) {
				return true;
			}
			return false;
		}
		
		private function loadExit(level:Map):void
		{
			//not sure this is working.
			var x:uint = level.deadEnds[0].x * level.getTileWidthInPixels();
			var y:uint = level.deadEnds[0].y * level.getTileHeightInPixels();
			var farthestExitPoint:FlxPoint = new FlxPoint(x, y);
			
			var farthestDistance:Number = Utils.getPathDistance(level.findPath(player.getMidpoint(), farthestExitPoint));
			
			for (var i:int = 0; i < level.deadEnds.length; i++)
			{
				x = level.deadEnds[i].x * level.getTileWidthInPixels();
				y = level.deadEnds[i].y * level.getTileHeightInPixels();
				var currentExitPoint:FlxPoint = new FlxPoint(x, y);
				
				var distance:Number = Utils.getPathDistance(level.findPath(player.getMidpoint(), currentExitPoint));
				if (distance > farthestDistance)
				{
					farthestDistance = distance;
					farthestExitPoint = currentExitPoint;
				}
			}
			
			exit = new FlxSprite(farthestExitPoint.x * level.getTileWidthInPixels() + 5, farthestExitPoint.y * level.getTileHeightInPixels() + 3, null);
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
		
		private function loadLights(level:Map):void
		{
			light = new Light(12, 12, darkness, player, level);
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
