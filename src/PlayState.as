package  
{
	import flash.text.engine.BreakOpportunity;
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source = "../bin/data/Background.png")] protected var BgTexture:Class;
		[Embed(source = "../bin/data/Background2.png")] protected var BgTexture2:Class;
		[Embed(source = "../bin/data/Background7-3.png")] protected var BgTexture7:Class;
		[Embed(source = "../bin/data/Exit4.png")] protected var ImgExit:Class;
		[Embed(source = "../bin/data/CloisterBlack.ttf", fontFamily = "TextFont", embedAsCFF="false")] protected var TextFont:String;
		
		//Model
		private var player:Player;
		private var levelNum:Number;
		private var level:Map;
		private var enemy:Enemy;
		private var item:Item;
		private var exit:FlxSprite;
		private var light:Light;
		private var enemiesreal:FlxGroup;
		private var enemieshallucination:FlxGroup;
		private var darkness:FlxSprite;
		private var lightning:Lightning;
		private var backgroundtemplate:FlxSprite;
		private var backgroundgroup:FlxGroup;
		private var currentExitPoint:FlxPoint;
		private var timetonames:Number = 6;
		private var namestimer:Number = 0;
		private var namesrendered:Boolean = false;
		private var textrenderer:TextRenderer;
		private var introTitleCounter:int = 0;
		
		//Controllers
		private var controllers:GameControllers;
		//Music controller
		private var musicController:MusicController;
		//Collision controller
		private var collisionController:CollisionController;
		
		private var EndColor:Number = 0xffffffff;
		
		private var validLocs:Array;

		override public function create():void
		{
			this.levelNum = FlxG.level;
			//Re-Init Items that were held
			if (this.levelNum == 1) {
				Persistence.initItemsHeld();
			}
			
			level = new Map(this.levelNum);
			
			textrenderer = new TextRenderer();

			var levelText:FlxText = new FlxText(0, 0, 70, "Level: " + levelNum);
			levelText.setFormat("TextFont", 16, 0xffffffff, "left");
			levelText.scrollFactor.x = levelText.scrollFactor.y = 0;
			

			//Create background
			backgroundtemplate = new FlxSprite(0, 0,BgTexture7);
			backgroundtemplate.solid = false;
			FlxG.bgColor = 0xff000000;
			var widthLimit:uint = Math.ceil(level.width/backgroundtemplate.width);
			var heightLimit:uint = Math.ceil(level.height / backgroundtemplate.height);
			backgroundgroup = new FlxGroup();
			//Thankfully, we always have 2^n members in this group :-)...right?
			for (var i:uint = 0; i < widthLimit; i++) {
				for (var j:uint = 0; j < heightLimit; j++) {
					var bg:FlxSprite = new FlxSprite(backgroundtemplate.width * i, backgroundtemplate.height * j, BgTexture7);
					bg.solid = backgroundtemplate.solid;
					backgroundgroup.add(bg);
				}
			}


			//Spawn player
			spawnPlayer(level);

			
			findValidLocations(level);
			

			//add enemies
			enemiesreal = new FlxGroup();
			enemieshallucination = new FlxGroup();
			/*
			 *  TODO:  Spawn enemies as function of level
			 */
			spawnEnemies(level);

			//Load darkness and lights
			loadDarkness();
			loadLights(level);

			add(backgroundgroup);
			add(level);
					
			
			//Load Exit
			loadExit(level);
			
			
			//Load Items
			spawnItems(level);
			
			add(player.getBloodSprite());
			add(player);
			add(player.getHitbox());						
			add(enemiesreal);
			for (var i:uint = 0; i < enemiesreal.members.length; i++) {
				var e:Enemy = enemiesreal.members[i] as Enemy;
				if(e){  //Check for null reference in 2^n size array
					add(e.getHitbox());
				}
			}
			add(enemieshallucination);
			for (var i:uint = 0; i < enemieshallucination.members.length; i++) {
				var e:Enemy = enemieshallucination.members[i] as Enemy;
				if(e){  //Check for null reference in 2^n size array
					add(e.getHitbox());
				}
			}

			//Set camera to follow player
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			FlxG.camera.follow(player);

			//Adjust world bounds to maze size
			FlxG.worldBounds.make( -10, -10, level.width+10, level.height+10);

			controllers = new GameControllers();
			musicController = new MusicController(player, enemy, exit);
			collisionController = new CollisionController(player, enemiesreal, enemieshallucination, exit, item, light, level, textrenderer);

			//Add controllers (player controller, enemy controllers, etc.)
			add(controllers);
			controllers.add(player.getController());
			for (var i:uint = 0; i < enemiesreal.members.length; i++) {
				var e:Enemy = enemiesreal.members[i] as Enemy;
				if(e){ //Check for null reference in 2^n size array
					controllers.add(e.getController());
				}	
			}		
			for (var i:uint = 0; i < enemieshallucination.members.length; i++) {
				var e:Enemy = enemieshallucination.members[i] as Enemy;
				if(e){ //Check for null reference in 2^n size array
					controllers.add(e.getController());
				}
			}
			
			checkPlayerInventory();

			controllers.add(light.getController());
			controllers.add(musicController);
			controllers.add(collisionController);
			add(darkness);
			lightning = new Lightning(darkness, player, enemiesreal,enemieshallucination);
			add(lightning);
			
			for (var i:uint = 0; i < enemiesreal.members.length; i++) {
				var e:Enemy = enemiesreal.members[i] as Enemy;
				if(e){  //Check for null reference in 2^n size array
					add(e.getEyeSprite());
				}
			}
			add(enemieshallucination);
			for (var i:uint = 0; i < enemieshallucination.members.length; i++) {
				var e:Enemy = enemieshallucination.members[i] as Enemy;
				if(e){  //Check for null reference in 2^n size array
					add(e.getEyeSprite());
				}
			}
			//add(titlegroup);
			
			
			if (levelNum != 0)
			{
				textrenderer.monoLevel(levelNum);//add(levelText);
			//}else {
			//	textrenderer.renderText(new FlxText(170, 10, 200, "Night Tower"), true, timetonames);
			}
			add(textrenderer);
			FlxG.flash(0xff000000, .75);
			
		}
		
		override public function update():void
		{
			/*
			if (FlxG.level == 0) {
				namestimer += FlxG.elapsed;
				if (!namesrendered && namestimer >= timetonames) {
					namesrendered = true;
					textrenderer.renderText(new FlxText(140, 10, 200, "Elliot Goodzeit - Design"), true, timetonames);
					textrenderer.renderText(new FlxText(140, 20, 200, "Alex Kuribayashi - Art n Sound"), true, timetonames);
					textrenderer.renderText(new FlxText(140, 30, 200, "Matthew Mitsui - AI n Graphics"), true, timetonames);
					textrenderer.renderText(new FlxText(140, 40, 200, "Jerry Reptak - Map generation"), true, timetonames);
				}
			}
			*/
			
			if (levelNum == 0)
			{
				if (player.x < 40 && introTitleCounter == 0)
				{
					var txt:FlxText = new FlxText(150, 50, 200, "Relentless Night");
					txt.scale.x = 2.0;
					txt.scale.y = 2.0;
					textrenderer.renderText(txt, true, 10);
					introTitleCounter++;
				}
				if (player.x > 90 && player.x < 100 && introTitleCounter == 1)
				{
					textrenderer.renderText(new FlxText(100, 200, 200, "Elliot Goodzeit"), true, 3);
					introTitleCounter++;
				}
				if (player.x > 190 && player.x < 200 && introTitleCounter == 2)
				{
					textrenderer.renderText(new FlxText(170, 90, 200, "Matt Mitsui"), true, 3);
					introTitleCounter++;
				}
				if (player.x > 240 && player.x < 250 && introTitleCounter == 3)
				{
					textrenderer.renderText(new FlxText(195, 210, 200, "Alex Kuribayashi"), true, 3);
					introTitleCounter++;
				}
				if (player.x > 300 && player.x < 320 && introTitleCounter == 4)
				{
					textrenderer.renderText(new FlxText(275, 60, 200, "Jerry Reptak"), true, 3);
					introTitleCounter++;
				}
				if (player.x > 400 && introTitleCounter == 5)
				{
					textrenderer.renderText(new FlxText(150, 230, 200, "Lonesome Wyatt and the Holy Spooks - \"So Far Away\""), true, 8);
					introTitleCounter++;
				}
			}
			
			if (levelNum == 9 && player.y > FlxG.height - 60)
			{
				FlxG.fade(EndColor, 3, switchToEndStateOnFadeComplete);
			}
			
			//Debug input
			if (FlxG.keys.ENTER && Constants.debug) {
				FlxG.resetState();
				Persistence.init();
			}
			if (FlxG.keys.N && Constants.debug) {
				FlxG.level++;
				if(FlxG.level <= 9){
					FlxG.switchState(new PlayState());
				}else {
					FlxG.switchState(new EndState());
				}
			}	
			
			super.update();
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
		
		private function spawnPlayer(level:Map):void {
			var playerStart:FlxPoint = Utils.tilePtToMidpoint(level, level.getStartTile());
			this.player = new Player(playerStart.x - 5, playerStart.y - 5);
			
			//Rotate player
			var levelStart:FlxPoint = level.getStartTile();
			var finalTile:FlxPoint;
			if (!level.isWall(levelStart.x + 1, levelStart.y)) { //RIGHT
				finalTile = Utils.tileToMidpoint(level, levelStart.x + 1, levelStart.y);
			}
			else if (!level.isWall(levelStart.x, levelStart.y + 1)) { //BOTTOM
				finalTile = Utils.tileToMidpoint(level, levelStart.x, levelStart.y + 1);
			}
			else if (!level.isWall(levelStart.x - 1, levelStart.y)) { //LEFT
				finalTile = Utils.tileToMidpoint(level, levelStart.x - 1, levelStart.y);
			}
			else if (!level.isWall(levelStart.x, levelStart.y - 1)) { //UP
				finalTile = Utils.tileToMidpoint(level, levelStart.x, levelStart.y - 1);
			}
			this.player.setAngle(finalTile);
		}
		
		private function spawnEnemy(enemyLowerBoundSpawn:Number, enemyUpperBoundSpawn:Number, level:Map, enemyType:uint = 1):void {
			if (this.validLocs.length > 0) {
				var point:FlxPoint = this.validLocs[Utils.randInt(validLocs.length*enemyLowerBoundSpawn, (validLocs.length - 1)*enemyUpperBoundSpawn)].loc;
		
				//Just set the hallucination argument to false
				enemy = new Enemy(point.x, point.y, this.player, level, false, enemyType, "fromcurrentposition");
				if(!enemy.isHallucination()) {
					enemiesreal.add(enemy);
				}
				else {
					enemieshallucination.add(enemy);
				}
			}
		}
		
		private function spawnEnemies(level:Map):void {
			switch(this.levelNum) {
				case 0:
					break;
				case 1:
					spawnEnemy(.40,.70,level, EnemyType.RANDOM_DFS);
					break;
					
				case 2:
					spawnEnemy(.40,.70,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.50,.90,level, EnemyType.RANDOM_DFS);
					break;
					
				case 3:
					spawnEnemy(.70, .90, level, EnemyType.RANDOM_DFS);
					spawnEnemy(.50, .60, level, EnemyType.RANDOM_DFS);
					spawnEnemy(.30, .40, level, EnemyType.RANDOM_DFS);
					break;
					
				case 4:
					spawnEnemy(.20, .50,level, EnemyType.UCS_PATHER);
					spawnEnemy(.50, .90,level, EnemyType.UCS_PATHER);
					spawnEnemy(.70, .90,level, EnemyType.RANDOM_DFS);
					break;
					
				case 5:
					spawnEnemy(.20, .50,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.20, .50,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.70, .90,level, EnemyType.RANDOM_DFS);
					break;
					
				case 6:
					spawnEnemy(.50, .70,level, EnemyType.UCS_PATHER);
					spawnEnemy(.20, .50,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.70, .90,level, EnemyType.RANDOM_DFS);
					break;
					
				case 7:
					spawnEnemy(.40, .60,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.20, .50,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.60,  1, level, EnemyType.RANDOM_DFS);
					spawnEnemy(.70, .90,level, EnemyType.RANDOM_DFS);
					break;
					
				case 8:
					spawnEnemy(.40, .60,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.20, .50,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.60,  1, level, EnemyType.RANDOM_DFS);
					spawnEnemy(.70, .90,level, EnemyType.RANDOM_DFS);
					spawnEnemy(.50, .70,level, EnemyType.UCS_PATHER);
					break;
				default:
			}
			
		}
		
		private function spawnItem(level:Map, itemType:ItemType):void {
			if (this.validLocs.length > 0) {
				var found:Boolean = false;
				/*
				 * Try to find random place to put item 10 times.
				 * If we spawn in the exit, try to find another location.
				 * We do a max of 10 times in case the only place to put it is exit.
				 */
				for (var i:uint = 0; i < 10; i++) {
					var point:FlxPoint = this.validLocs[Utils.randInt(validLocs.length * Constants.itemPlacePercent, validLocs.length - 1)].loc;
					if ( (Utils.pointToTileCoords(level, point).x != Utils.pointToTileCoords(level, this.exit.getMidpoint()).x)
						&& (Utils.pointToTileCoords(level, point).y != Utils.pointToTileCoords(level, this.exit.getMidpoint()).y)) {
							found = true;
							break;
					}
				}
				
				// Don't add if only spawn point is on exit
				if (found) {
					item = new Item(point.x,point.y,player,level,itemType);
					add(item);
				}
			}
		}
		
		private function spawnItems(level:Map):void {
			if(this.levelNum !=0) {
				if (Constants.itemSpawnPercent >= Utils.randInt(0, 100)) {
					var randItem:Number = Utils.randInt(0, 2);
					switch(randItem) {
						case 0:
							if(Persistence.itemsSeen.indexOf(0) == -1) {
								spawnItem(level, ItemType.LANTERN);
								Persistence.itemsSeen.push(0);
							}
							break;
						case 1:
							if(Persistence.itemsSeen.indexOf(1) == -1) {
								spawnItem(level, ItemType.CLOCK);
								Persistence.itemsSeen.push(1);

							}
							break;
						case 2:
							if(Persistence.itemsSeen.indexOf(2) == -1) {
								spawnItem(level, ItemType.UMBRELLA);
								Persistence.itemsSeen.push(2);

							}
							break;
					}
				}
			}
		}

		private function loadExit(level:Map):void {			
			if (this.validLocs.length > 0) {
				var point:FlxPoint = this.validLocs[Utils.randInt(validLocs.length*Constants.exitPlacePercent, validLocs.length - 1)].loc;

				var mazeLoc:FlxPoint = Utils.pointToTileCoords(level, point);
				
				var propWidth:Number = mazeLoc.x / (level.getMaze().getWidth() - 2);
				var propHeight:Number = mazeLoc.y / (level.getMaze().getHeight() - 2);
				Persistence.startLocRatio.make(propWidth, propHeight);
				
				exit = new FlxSprite(point.x, point.y, null);
				//exit.makeGraphic(12, 16, 0xff8B8682);
				exit.loadGraphic(ImgExit);
				var point:FlxPoint = Utils.getPointThatCentersObject(level, exit);
				exit.x = point.x;
				exit.y = point.y;
				if (levelNum != 9)
				{
				add(exit);
				}
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
		}
		
		private function checkPlayerInventory():void
		{
			if (player.playerHasItem(ItemType.LANTERN))
			{
				light.loadLantern();
				player.loadLantern();
			}
			if (player.playerHasItem(ItemType.CLOCK))
			{
				player.maxVelocity.x = 62;
				player.maxVelocity.y = 62;
			}
		}
		
		private function switchToEndStateOnFadeComplete():void
		{
			FlxG.switchState(new EndState());
		}
	}

}
