package  
{
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
		[Embed(source = "../bin/data/autotiles3.png")] public var MapTiles:Class;
//		[Embed(source = "../bin/data/large_tiles.png")] public var MapTiles:Class;
		
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
			else {				
				mazeDifficulty();
			}
			
			var levelArray:Array = maze.to1DArray();
			loadMap(arrayToCSV(levelArray, maze.getWidth()), MapTiles, 0, 0, FlxTilemap.AUTO);
			
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
					_width = 14;
					_height = 12;
					_factor = 0.08;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
				
				case 2:
					_width = 16;
					_height = 13;
					_factor = 0.07;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
				
				case 3:
					_width = 20;
					_height = 16;
					_factor = 0.06;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 4:
					_width = 24;
					_height = 18;
					_factor = 0.06;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 5:
					_width = 30;
					_height = 24;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 6:
					_width = 30;
					_height = 26;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				case 7:
					_width = 30;
					_height = 28;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;

				case 8:
					_width = 32;
					_height = 24;
					_factor = 0.05;
					_wallsToRemove = (_height - 2) * (_width - 2) * _factor;	
					break;
					
				default:
					_width = 10;
					_height = 10;
					_wallsToRemove = 0;	
			}
		
			this.maze.generateRandMaze(_width, _height, _wallsToRemove);
		}
		
		public function isWall(x:uint, y:uint):Boolean {
			var mazeArr:Array = this.maze.getMazeArray();
			
			if (	   (x >= this.maze.getWidth())
					|| (y >= this.maze.getHeight())
					|| (y < 0)
					|| (x < 0)
					|| (mazeArr[x][y] == 1) ) {
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
			return this.maze.getStartTile();
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
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
				];
			
			var startPt:FlxPoint = new FlxPoint(4, 1);
			var endPt:FlxPoint = new FlxPoint(4, level1Data[0].length - 2);
			maze.generateFixedMaze(level1Data, startPt, endPt);
		}		
	}

}
