package  
{
	/* Algorithm from:
	 * http://www.emanueleferonato.com/2008/12/08/perfect-maze-generation-tile-based-version-as3/
	 */
	
	import flash.automation.ActionGenerator;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import org.flixel.FlxPoint;
	/**
	 * Maze in tiles of walls and not walls.
	 * @author Darkness
	 */
	public class Maze 
	{
		//directions
		private const NORTH				: String = "N";
		private const SOUTH				: String = "S";
		private const EAST				: String = "E";
		private const WEST				: String = "W";
		
		//variables
		private var _width		: uint;
		private var _height		: uint;
		
		private var _maze		: Array;
		private var _moves		: Array;
		
		private var _start		: FlxPoint;
		private var _finish		: FlxPoint;

		private var deadEnds:Array;
		private var corners:Array;
		
		/**
		 * Create a maze
		 * @param	width In number of tiles
		 * @param	height In number of tiles
		 */
		public function Maze() {
			this._maze = null;
			this.deadEnds = new Array();
			this.corners = new Array();
		}
		
		public function generateRandMaze(width:uint, height:uint, numWallsRemove:uint):void {
			if (_maze == null) {
				this._width = width;
				this._height = height;
				_generate(numWallsRemove);
			}
		}
		
		public function generateFixedMaze(levelData:Array, start:FlxPoint, end:FlxPoint):void {
			if (_maze == null) {
				this._maze = levelData.slice(0);
				this._width = levelData[0].length;
				this._height = levelData.length;
				
				this._start = start;
				this._finish = end;
				_findDeadEnds();
				_findCorners();
			}
		}
		
		public function getHeight():uint {
			return _height;
		}
		
		public function getWidth():uint {
			return _width;
		}
		
		public function getMazeArray():Array {
			return this._maze;
		}
		
		public function getStartTile():FlxPoint {
			return this._start;
		}
		
		public function getFinishTile():FlxPoint {
			trace("maze", this._finish.x, this._finish.y);
			return this._finish;
		}
		
		/**
		 * Return the 1-D array representation of the maze
		 * @return 1-D Array representation of the maze
		 */
		public function to1DArray():Array {
			var mazeArr:Array = new Array();
		
			for (var i:uint = 0; i < getHeight(); i++) {
				for (var j:uint = 0; j < getWidth(); j++) {
					mazeArr.push(_maze[i][j]);
				}
			}
			return mazeArr;
		}
		
		public function getDeadEnds() : Array {
			return this.deadEnds;
		}
		
		public function getCorners() : Array {
			return this.corners;
		}
		
		private function _generate(numWalls:uint = 0) : void {
			_initMaze();
			_createMaze();
			_removeRandWalls(numWalls);
			_emptyOut(_start, 3, 3);
			_findDeadEnds();
			_findCorners();
		}
 
		private function _initMaze() : void {
			
			_start = new FlxPoint(1, 1);
			_finish = new FlxPoint(_width - 3, _height - 3);
			
			_maze	= new Array(_width);
			
			for ( var x : int = 0; x < _height; x++ )
			{
				_maze[x] = new Array(_height);
 
				for ( var y : int = 0; y < _width; y++ )
				{
					_maze[x][y] = 1;
				}
			}
 
			_maze[_start.x][_start.y] = 0;
		}
		
		private function _createMaze() : void {
			var back				: int; 
			var move				: int;
			var possibleDirections	: String;
			var pos					: FlxPoint = new FlxPoint(_start.x, _start.y);
			var lastPossDirection:String = "";
 
			_moves = new Array();
			_moves.push(pos.y + (pos.x * _width));
			
			
			while ( _moves.length )
			{
				lastPossDirection = possibleDirections;
				possibleDirections = "";
 
				if ((pos.x + 2 < _height ) && (_maze[pos.x + 2][pos.y] == true) && (pos.x + 2 != false) && (pos.x + 2 != _height - 1) )
				{
					possibleDirections += SOUTH;
				}
 
				if ((pos.x - 2 >= 0 ) && (_maze[pos.x - 2][pos.y] == true) && (pos.x - 2 != false) && (pos.x - 2 != _height - 1) )
				{
					possibleDirections += NORTH;
				}
 
				if ((pos.y - 2 >= 0 ) && (_maze[pos.x][pos.y - 2] == true) && (pos.y - 2 != false) && (pos.y - 2 != _width - 1) )
				{
					possibleDirections += WEST;
				}
 
				if ((pos.y + 2 < _width ) && (_maze[pos.x][pos.y + 2] == true) && (pos.y + 2 != false) && (pos.y + 2 != _width - 1) )
				{
					possibleDirections += EAST;
				}
//BEGIN removal of walls				
				if ((pos.y + 2 < _width) && (_maze[pos.x][pos.y + 2] == false)) 
				{
					if (Utils.randInt(0, 100) < 10 && pos.x > 4 && pos.y > 5)
					{
						_maze[pos.x][pos.y + 1] = 0;
					}
				}
				
				if ((pos.x -2 >= 0) && (_maze[pos.x - 2][pos.y] == false))
				{
					if (Utils.randInt(0, 100) < 10 && pos.x > 4 && pos.y > 4)
					{
						_maze[pos.x - 1][pos.y] = 0;
					}
				}
	
//END removal of walls
				if ( possibleDirections.length > 0 )
				{

					move = Utils.randInt(0, (possibleDirections.length - 1));
 
					switch ( possibleDirections.charAt(move) )
					{
						case NORTH: 
							_maze[pos.x - 2][pos.y] = 0;
							_maze[pos.x - 1][pos.y] = 0;
							pos.x -=2;
							break;
 
						case SOUTH: 
							_maze[pos.x + 2][pos.y] = 0;
							_maze[pos.x + 1][pos.y] = 0;
							pos.x +=2;
							break;
 
						case WEST: 
							_maze[pos.x][pos.y - 2] = 0;
							_maze[pos.x][pos.y - 1] = 0;
							pos.y -=2;
							break;
 
						case EAST: 
							_maze[pos.x][pos.y + 2] = 0;
							_maze[pos.x][pos.y + 1] = 0;
							pos.y +=2;
							break;        
					}
									
					_moves.push(pos.y + (pos.x * _width));
				}
				else
				{
					back = _moves.pop();
					pos.x = int(back / _width);
					pos.y = back % _width;
				}
				
			}
		}
	
		/**
		 * Make everything starting at location into walkable tiles
		 * Example:
		 * l = Location, x=4 y=2
		 * 	l+++
		 * 	++++
		 * 
		 * @param	FlxPoint location
		 * @param	x Number of tiles along x direction to remove
		 * @param	y Number of tiles along y direction to remove
		 */
		private function _emptyOut(location:FlxPoint, x:uint, y:uint) : void {
			var beginX:uint = location.x;
			var beginY:uint = location.y;
			
			for ( var i: uint = beginY; (i < beginY + y) && (i < getHeight()); i++) {
				for ( var j: uint = beginX; (j < beginX + x) && (j < getWidth()); j++) {
					_maze[i][j] = 0;
				}
			}
		}
	
		private function _findDeadEnds() : void {
			
			for (var i:uint = 1; i < getHeight() - 1; i++) {
				for (var j:uint = 1; j < getWidth() - 1; j++) {
					
					if(_maze[i][j] == 0) {					
						var sum:uint = 	_maze[i - 1][j]  //TOP
									  + _maze[i + 1][j]  //BOTTOM
									  + _maze[i][j - 1]  //LEFT
									  + _maze[i][j + 1]; //RIGHT
						
						if(sum == 3) {
							deadEnds.push(new FlxPoint(j, i));
						}
					}
				}
			}
		}
		
		private function _findCorners() : void {
			for (var i:uint = 1; i < getHeight() - 1; i++) {
				for (var j:uint = 1; j < getWidth() - 1; j++) {
					
					if (_maze[i][j] == 0) {
						var sum:uint = 0;
						if (_maze[i - 1][j]) sum += 1; //TOP
						if (_maze[i + 1][j]) sum += 1; //BOTTOM
						if (_maze[i][j - 1]) sum += 2; //LEFT
						if (_maze[i][j + 1]) sum += 2; //RIGHT
						
						if (sum == 3) {
							this.corners.push(new FlxPoint(j, i));
						}
					}
				}
			}
		}
		
		private function _removeRandWalls(numWalls:uint): void {
			for ( var i:uint = 0; i < numWalls; i++) {
				do {
					var xWall:int = Utils.randInt(1, _height-3);
					var yWall:int = Utils.randInt(1, _width-3);
				} while (_maze[xWall][yWall] == 0);
				_maze[xWall][yWall] = 0;
			}
		}
	}

}
