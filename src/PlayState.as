package  
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		/*[Embed(source = "../bin/data/music.mp3")] protected var BgMusic:Class;
		[Embed(source = "../bin/data/chase_music.mp3")] protected var ChaseMusic:Class;
		[Embed(source = "../bin/data/win_music.mp3")] protected var WinMusic:Class;*/
		[Embed(source = "../bin/data/Background.png")] protected var BgTexture:Class;
		[Embed(source = "../bin/data/Background2.png")] protected var BgTexture2:Class;
		[Embed(source = "../bin/data/Background3.png")] protected var BgTexture3:Class;
		
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
		
		private var background:FlxSprite;
		
		private var currentExitPoint:FlxPoint;
		//Controllers
		private var controllers:GameControllers;
		
		//Music controller
		private var musicController:MusicController;
		
		private var collisionController:CollisionController;
		
		
		
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
			
			background = new FlxSprite(0, 0,BgTexture3);
			background.solid = false;
			FlxG.bgColor = 0xffC9C9C9;
			
			//Create player, map, enemies, exit, darkness, lights, and respective controllers
			
						
			level = new Map(36,28,true);
			//level = new Map(0, 0, false);
			
			var playerStart:FlxPoint = Utils.tilePtToMidpoint(level, level.getStartTile());
			player = new Player(playerStart.x - 5, playerStart.y - 5);
			
			
			
			enemies = new FlxGroup();
			spawnEnemy(level);
			
			loadDarkness();
			loadLights(level);
			
			add(background);
			add(level);
			add(player);			
			add(enemies);

			loadExit();
			
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			FlxG.camera.follow(player);
			
			//Adjust world bounds to maze size
			FlxG.worldBounds.make( -10, -10, level.width+10, level.height+10);
			
			//enemyTwo = new Enemy(14, 210);
			//add(enemyTwo);
			
			
			controllers = new GameControllers();
			musicController = new MusicController(player, enemy, exit);
			collisionController = new CollisionController(player, enemies, exit);

			add(controllers);
			//TODO:  Have a controller?
			controllers.add(player.getController());
			controllers.add(enemy.getController());
			controllers.add(light.getController());
			//controllers.add(flashlight.getController());
			controllers.add(musicController);
			controllers.add(collisionController);
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
		
		
		private function spawnEnemy(level:Map):void {
			var xlocMaze:uint = 0;
			var ylocMaze:uint = 0;
			
			var xMin:uint = level.getMaze().getWidth()  * (2.0/5.0);
			var yMin:uint = level.getMaze().getHeight() * (2.0/5.0);
			
			var found:Boolean = false;
			for (var i:uint = 0; i < level.deadEnds.length; i++) {
				var dead:FlxPoint = level.deadEnds[i];
				xlocMaze = dead.x;
				ylocMaze = dead.y;
				
				if (   (xlocMaze >= xMin) 
					&& (ylocMaze >= yMin)
					&& (xlocMaze < level.getMaze().getWidth())
					&& (ylocMaze < level.getMaze().getHeight())   ) {
						
						found = true;
						break;
				}			
			}
			
			//Couldn't find any dead ends
			if (!found) {
				
				trace("Enemy: No dead ends!");
				
				/*
				var end:FlxPoint = findValidLocation(level);
				if (end == null) {
					trace("NULL!");
				}*/
				
				xlocMaze = level.getMaze().getFinishTile().x;
				ylocMaze = level.getMaze().getFinishTile().y;
			}
			
			var xlocPix:int = level.getTileWidthInPixels() * xlocMaze;
			var ylocPix:int = level.getTileHeightInPixels() * ylocMaze;
			trace("Enemy: xloc", xlocPix);
			trace("Enemy: yloc", ylocPix);
			
			enemy = new Enemy(xlocPix, ylocPix, this.player, level);
			enemies.add(enemy);
			
		}

		private function loadExit():void
		{			
			var xMin:uint = level.getMaze().getWidth() * (3.0 / 5.0);
			var yMin:uint = level.getMaze().getHeight() * (3.0 / 5.0);
			
			var xlocMaze:uint = 0;
			var ylocMaze:uint = 0;
			
			var found:Boolean = false;
			for (var i:uint = 0; i < level.deadEnds.length; i++) {
				var dead:FlxPoint = level.deadEnds[i];
				xlocMaze = dead.x;
				ylocMaze = dead.y;
								
				if (   (xlocMaze >= xMin) 
					&& (ylocMaze >= yMin)
					&& (xlocMaze < level.getMaze().getWidth())
					&& (ylocMaze < level.getMaze().getHeight())   ) {
						
						found = true;
						break;
				}			
			}
			
			//Couldn't find any dead ends
			if (!found) {
				
				trace("Exit: No dead ends!");
				
				/*
				var end:FlxPoint = findValidLocation(level);
				if (end == null) {
					trace("NULL!");
				}*/
				
				xlocMaze = level.getMaze().getFinishTile().x;
				ylocMaze = level.getMaze().getFinishTile().y;

			}
			
			var xlocPix:int = level.getTileWidthInPixels() * xlocMaze;
			var ylocPix:int = level.getTileHeightInPixels() * ylocMaze;
			
			exit = new FlxSprite(xlocPix + 5, ylocPix + 3, null);
			exit.makeGraphic(12, 16, 0xff8B8682);
			add(exit);
		}
		
		
/*	ORIGINAL	
		private function spawnEnemy(x:Number, y:Number):void
		{
			enemy = new Enemy(x, y,this.player, level);
			enemies.add(enemy);
			
		}
		
				private function loadExit():void
		{
			//not sure this is working.
			currentExitPoint = level.deadEnds[0];
			var currentDistance:Number = Utils.getDistance(player.getMidpoint(), currentExitPoint);
			for (var i:int = 0; i < level.deadEnds.length; i++)
			{
				var distance:Number = Utils.getDistance(player.getMidpoint(), level.deadEnds[i]);
				if (currentDistance > distance)
				{
					currentDistance = distance;
					currentExitPoint = level.deadEnds[i];
				}
			}
			exit = new FlxSprite(currentExitPoint.y * 24 + 5, currentExitPoint.x * 24 + 3, null);
			exit.makeGraphic(12, 16, 0xff8B8682);
			add(exit);
		}
*/	
/* EXPERIMENTAL
	
		
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
*/		


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
