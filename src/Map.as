package  
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Map extends FlxTilemap
	{
		[Embed(source = "../bin/data/autotiles2.png")] public var MapTiles1:Class;
		[Embed(source = "../bin/data/autotiles3.png")] public var MapTiles2:Class;
		[Embed(source = "../bin/data/autotiles5.png")] public var MapTiles3:Class;
		[Embed(source = "../bin/data/autotiles10.png")] public var MapTiles4:Class;
		[Embed(source = "../bin/data/autotiles4.png")] public var MapTiles5:Class;
		
		public var levelNum:Number;

		public var maze:Maze;
		public var deadEnds:Array;
		public var corners:Array;
		
		/**
		 * Create a map.
		 * @param	width In number of tiles
		 * @param	height In number of tiles
		 * @param	random If the maze should be random or not
		 */
		
		public function Map(levelNum:Number) {
			this.levelNum = levelNum;
			
			this.maze = new Maze();
			
			if(levelNum == 0) {
				loadLevel1Data();
			}
			else if (levelNum == Constants.purgatoryLevel) {
				loadPurgatoryData();
			}
			else if (levelNum == Constants.finalLevel){
				loadFinalLevelData();
			}				
			else {
				mazeDifficulty();
			}
			
			
			var levelArray:Array = maze.to1DArray();
			switch(this.levelNum) {
				case 0:
					loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles1, 0, 0, FlxTilemap.AUTO);
					break;
				case 1:
				case 2:
					loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles2, 0, 0, FlxTilemap.AUTO);
					break;
					
				case 3:
				case 4:
					loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles3, 0, 0, FlxTilemap.AUTO);
					break;
					
				case 5:
				case 6:
					loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles4, 0, 0, FlxTilemap.AUTO);
					break;
					
				case 7:
				case 8:
					loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles5, 0, 0, FlxTilemap.AUTO);
					break;
				default:
					loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles1, 0, 0, FlxTilemap.AUTO);
					break;
			}
			
			this.deadEnds = maze.getDeadEnds();
			this.corners = maze.getCorners();
		}
		
		private function mazeDifficulty():void {
			var _width:uint;
			var _height:uint;
			
			var _factor:Number = 0;
			var _wallsToRemove:uint = 0;
			
			switch(this.levelNum)  {
				case 1:
					_width = 18;
					_height = 14;
					_factor = 0.08;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;
					
					break;
				
				case 2:
					_width = 18;
					_height = 14;
					_factor = 0.07;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
				
				case 3:
					_width = 19;
					_height = 15;
					_factor = 0.06;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 4:
					_width = 19;
					_height = 15;
					_factor = 0.06;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 5:
					_width = 21;
					_height = 17;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 6:
					_width = 21;
					_height = 17;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 7:
					_width = 24;
					_height = 20;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;

				case 8:
					_width = 24;
					_height = 20;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				default:
					_width = 10;
					_height = 10;
					_wallsToRemove = 0;	
			}
			
			var ratioX:Number = Persistence.startLocRatio.x;
			var ratioY:Number = Persistence.startLocRatio.y;
			
			
			var _xStart:Number = ratioX * (_width as Number);
			var _yStart:Number = ratioY * (_height as Number);
			
			
			var _start:FlxPoint = new FlxPoint(_xStart, _yStart);
			
			this.maze.generateRandMaze(_width, _height, _wallsToRemove, _start);
		}
		
		public function isWall(x:uint, y:uint):Boolean {
			var mazeArr:Array = this.maze.getMazeArray();
			
			if (	   (x >= this.maze.getWidth())
					|| (y >= this.maze.getHeight())
					|| (y < 0)
					|| (x < 0)
					|| (mazeArr[y][x] == 1) ) {
				return true;
			}
			return false;
		}

		
		public function getMaze():Maze {
			return this.maze;
		}
		
		/**
		 * Get width of single tile in pixels
		 * @return
		 */
		public function getTileWidthInPixels():uint {
			return this._tileWidth;
		}
		
		/**
		 * Get height of single tile in pixels.
		 * @return
		 */
		public function getTileHeightInPixels():uint {
			return this._tileHeight;
		}
		
		/**
		 * Get the start point in tiles
		 * @return
		 */
		public function getStartTile():FlxPoint {
			return new FlxPoint(this.maze.getStartTile().y, this.maze.getStartTile().x);
		}
		
		/**
		 * Get the end point in tiles
		 * @return
		 */
		public function getEndTile():FlxPoint {
			return this.maze.getFinishTile();
		}
		
		private function loadLevel1Data():void
		{
			var level1Data:Array = [
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
				];
			
			var startPt:FlxPoint = new FlxPoint(1, 4);
			var endPt:FlxPoint = new FlxPoint(4, level1Data[0].length - 2);
			maze.generateFixedMaze(level1Data, startPt, endPt);
		}
		
		private function loadPurgatoryData():void
		{
			var purgatoryData:Array = [
					[1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1]
				];
			
			var startPt:FlxPoint = new FlxPoint(1, 1);
			var endPt:FlxPoint = new FlxPoint(purgatoryData.length - 1, purgatoryData[0].length - 1);
			maze.generateFixedMaze(purgatoryData, startPt, endPt);
		}
		
		private function loadFinalLevelData():void
		{
			var finalLevelData:Array = [
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 0, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 0, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 0, 1, 1, 1, 1, 1],
					[1, 1, 1, 0, 0, 0, 1, 1, 1, 1],
					[1, 1, 1, 0, 0, 0, 1, 1, 1, 1],
					[1, 1, 1, 0, 0, 0, 1, 1, 1, 1],
					[1, 1, 1, 0, 0, 0, 1, 1, 1, 1],
					[1, 1, 1, 0, 0, 0, 1, 1, 1, 1],
				];
			
			var startPt:FlxPoint = new FlxPoint(4, 1);
			var endPt:FlxPoint = new FlxPoint(4, 6);
			maze.generateFixedMaze(finalLevelData, startPt, endPt);
			
		}
		public function getMapWidthInTiles():uint {
			return this.maze.getWidth();
		}
		
		public function getMapHeightInTiles():uint {
			return this.maze.getHeight();
		}
	}

}
