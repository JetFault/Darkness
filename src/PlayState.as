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
		[Embed(source = "../bin/data/Background7.png")] protected var BgTexture7:Class;
		//Model
		private var player:Player;
		private var level:Map;
		private var enemy:Enemy;
		private var exit:FlxSprite;
		private var light:Light;
		private var enemiesreal:FlxGroup;
		private var enemieshallucination:FlxGroup;
		private var darkness:FlxSprite;
		private var lightning:Lightning;
		private var backgroundtemplate:FlxSprite;
		private var backgroundgroup:FlxGroup;
		private var currentExitPoint:FlxPoint;
		
		//Controllers
		private var controllers:GameControllers;
		//Music controller
		private var musicController:MusicController;
		//Collision controller
		private var collisionController:CollisionController;
		
		
		private var validLocs:Array;

		override public function create():void
		{

			
			
			//Create player, map, enemies, exit, darkness, lights, and respective controllers
			level = new Map(18, 14, true);
			
			//Create background
			backgroundtemplate = new FlxSprite(0, 0,BgTexture7);
			backgroundtemplate.solid = false;
			FlxG.bgColor = 0xffC9C9C9;
			var widthLimit:uint = Math.ceil(level.width/backgroundtemplate.width);
			var heightLimit:uint = Math.ceil(level.height / backgroundtemplate.height);
			backgroundgroup = new FlxGroup();
			for (var i:uint = 0; i < widthLimit; i++) {
				for (var j:uint = 0; j < heightLimit; j++) {
					var bg:FlxSprite = new FlxSprite(backgroundtemplate.width * i, backgroundtemplate.height * j, BgTexture3);
					bg.solid = backgroundtemplate.solid;
					backgroundgroup.add(bg);
				}
			}

			
			//add player
			var playerStart:FlxPoint = Utils.tilePtToMidpoint(level, level.getStartTile());
			player = new Player(playerStart.x - 5, playerStart.y - 5);
			findValidLocations(level);
/*TRACING			
			for (var i:uint = 0; i < this.validLocs.length; i++) {
				trace("Pt x", validLocs[i].loc.x, " Pt y", validLocs[i].loc.y);
				trace("Dist", validLocs[i].distance);
			}
*/
			
			//add enemies
			enemiesreal = new FlxGroup();
			enemieshallucination = new FlxGroup();
			/*
			 *  TODO:  Spawn enemies as function of level
			 */
			spawnEnemy(level,false);
			
			//Load darkness and lights
			/*
			 * 
			 */ 
			loadDarkness();
			loadLights(level);
			
			add(backgroundgroup);
			add(level);
			add(player);			
			add(enemiesreal);
			add(enemieshallucination);

			loadExit(level);
			
			//Set camera to follow player
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			FlxG.camera.follow(player);
			
			//Adjust world bounds to maze size
			FlxG.worldBounds.make( -10, -10, level.width+10, level.height+10);
			
			
			controllers = new GameControllers();
			musicController = new MusicController(player, enemy, exit);
			collisionController = new CollisionController(player, enemiesreal, enemieshallucination, exit);

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
		
		private function findValidLocations(level:Map):void {
			var xlocMaze:uint = 0;
			var ylocMaze:uint = 0;
			
			var pt:FlxPoint;
			var midpt:FlxPoint;
			var dist:Number;
			var i:uint;
			
			this.validLocs = new Array();
			
			/* Discover all possible dead ends */
			for (i = 0; i < level.deadEnds.length; i++) {
				xlocMaze = level.deadEnds[i].x;
				ylocMaze = level.deadEnds[i].y;
				
				midpt = Utils.tileToMidpoint(level, xlocMaze, ylocMaze);
				dist = Utils.getPathDistance(level.findPath(midpt, this.player.getMidpoint()));
				
				if (dist != 0) {
					pt = new FlxPoint(xlocMaze * level.getTileWidthInPixels(), ylocMaze * level.getTileHeightInPixels());
					validLocs.push({loc:pt, distance:dist});
				}				
			}
			
			/* Discover all possible corners */
			for (i = 0; i < level.corners.length; i++) {
				xlocMaze = level.corners[i].x;
				ylocMaze = level.corners[i].y;
				
				midpt = Utils.tileToMidpoint(level, xlocMaze, ylocMaze);
				dist = Utils.getPathDistance(level.findPath(midpt, this.player.getMidpoint()));
				
				if (dist != 0) {
					pt = new FlxPoint(xlocMaze * level.getTileWidthInPixels(), ylocMaze * level.getTileHeightInPixels());
					validLocs.push({loc:pt, distance:dist});
				}
			}
			
			validLocs.sortOn('distance', Array.NUMERIC);
		}
		
		private function spawnEnemy(level:Map, hallucination:Boolean = false):void {
			
			if (this.validLocs.length > 0) {
				
				var startPercent:Number = 0.60;
				
				var point:FlxPoint = this.validLocs[Utils.randInt(validLocs.length*startPercent, validLocs.length - 1)].loc;
		
				enemy = new Enemy(point.x, point.y, this.player, level, hallucination);
				if(!hallucination) {
					enemiesreal.add(enemy);
				}
				else {
					enemieshallucination.add(enemy);
				}
			}
		}

		private function loadExit(level:Map):void {			
			
			if (this.validLocs.length > 0) {
				
				var startPercent:Number = 0.75;
				
				var point:FlxPoint = this.validLocs[Utils.randInt(validLocs.length*startPercent, validLocs.length - 1)].loc;
		
				exit = new FlxSprite(point.x, point.y, null);
				exit.makeGraphic(12, 16, 0xff8B8682);
				add(exit);
				
			}
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
