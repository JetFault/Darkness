package  
{
	import flash.geom.Point;
	/**
	 * Algorithm from:
	 * http://www.emanueleferonato.com/2008/12/08/perfect-maze-generation-tile-based-version-as3/
	 *
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
		
		private var _start		: Point;
		private var _finish		: Point;
		
		public function Maze(width:uint, height:uint) {
			this._width = width;
			this._height = height;
			
			_generate();
		}
		
		public function getHeight():uint {
			return _height;
		}
		
		public function getWidth():uint {
			return _width;
		}
		
		public function toArray():Array {
			var mazeArr:Array = new Array();
		
			for (var i:uint = 0; i < getHeight(); i++) {
				for (var j:uint = 0; j < getWidth(); j++) {
					mazeArr.push(_maze[i][j]);
				}
			}
			return mazeArr;
		}
		
		
		private function _generate () : void {
			_initMaze();
			_createMaze();
		}
 
		private function _initMaze () : void {
			
			_start = new Point(1, 1);
			
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
 
		private function _createMaze () : void {
			var back				: int;
			var move				: int;
			var possibleDirections	: String;
			var pos					: Point = _start.clone();
 
			_moves = new Array();
			_moves.push(pos.y + (pos.x * _width));
 
			while ( _moves.length )
			{
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
 
				if ( possibleDirections.length > 0 )
				{
					move = _randInt(0, (possibleDirections.length - 1));
 
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
		
		private function _randInt ( min : int, max : int ) : int {
			return int((Math.random() * (max - min + 1)) + min);
		}
	}

}