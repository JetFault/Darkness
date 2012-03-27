package  
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Utils 
	{
		
		public static function getDistance(p1:FlxPoint, p2:FlxPoint):Number
		{
			var xDist:Number = p1.x - p2.x;
			var yDist:Number = p1.y - p2.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}
		
		
		public static function tileToMidpoint(map:Map, x:Number, y:Number):FlxPoint {
			
			if (x < 0 || y < 0 || x >= map.widthInTiles || y > map.heightInTiles) {
				return new FlxPoint( -1, -1);
			}
			
			var tilewidth:Number = map.getTileWidth();
			var tileheight:Number = map.getTileHeight();
			
			return new FlxPoint(tilewidth * x + tilewidth / 2 - 1, tileheight * y + tileheight / 2 - 1);
		}
		
		public static function tilePtToMidpoint(map:Map, flxPoint:FlxPoint):FlxPoint {
			return tileToMidpoint(map, flxPoint.x, flxPoint.y);
		}
		
		public static function pointToTileCoords(map:Map, point:FlxPoint):FlxPoint {
			var tilewidth:Number = map.getTileWidth();
			var tileheight:Number = map.getTileHeight();
			
			if (point.x < 0 || point.y < 0 || point.x>= map.widthInTiles*tilewidth|| point.y > map.heightInTiles*tileheight) {
				return new FlxPoint(-1,-1);
			}
			
			return new FlxPoint(Math.floor(point.x / tilewidth), Math.floor(point.y / tileheight));
		}
		
		public static function createDFSPath(map:Map, depth:Number, enemy:Enemy):Array {
			
			//Initialization
			var starttile:FlxPoint = Utils.pointToTileCoords(map, enemy.getMidpoint());
			var root:Array = new Array(starttile.x, starttile.y, 0);	
						
			var closed:Array = new Array();			
			var frontier:Array = new Array();
			frontier.push(root);
			
			//DFS loop
			while (frontier.length > 0) {
				//Get next node on frontier
				//frontier = frontier.reverse();
				var node:Array = frontier.pop();
				//frontier = frontier.reverse();
				var inclosed:Boolean = false;

				//Base case: depth
				if (node[2] >= depth) {
					continue;
				}
					
				//Base case: Node has already been visited
				for each (var elem:Array in closed) {
					if (elem[0] == node[0] && elem[1] == node[1]) {
						inclosed = true;
						break;
					}
				}	
				if (inclosed) {
					continue;
				}
					
					
				//Node has not been visited.  Push to closed	
				closed.push(node);
				//Get neighbors
				for each(var dx:Number in new Array( -1, 0, 1)) {
					for each(var dy:Number in new Array( -1, 0, 1)) {
						if (dx != 0 && dy != 0) {
							continue;
						}
						
						var alsoinclosed:Boolean = false;
						var p3:Array = new Array(0,0,0);
						p3[0] = node[0] + dx;
						p3[1] = node[1] + dy;
						p3[2] = node[2] + 1;
						
						trace(map.getTile(p3[0], p3[1]));
						//If not empty point in maze, skip
						if (map.getTile(p3[0], p3[1]) != 0 ) {
							continue;
						}

						//If not in closed, push it to frontier
						for each (var anotherelem:Array in closed) {
							if (anotherelem[0] == p3[0] && anotherelem[1] == p3[1]) {
								alsoinclosed = true;
										break;
							}
						}
						if (!alsoinclosed) {
							frontier.push(p3);
						}
					}
				}
				
			}
			return closed;
		}
	}

}