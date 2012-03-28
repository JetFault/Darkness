package  
{
	import org.flixel.FlxPath;
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
		
		//not sure this works properly
		public static function getPathDistance(path:FlxPath):Number
		{
			var distance:Number = 0;
			for (var i:int = 0; i++; i < path.nodes.length-1)
			{
				distance += getDistance(path.nodes[i], path.nodes[i + 1]);
			}
			return distance;
		}
		
		
		public static function tileToMidpoint(map:Map, x:Number, y:Number):FlxPoint {
			if (x < 0 || y < 0 || x >= map.widthInTiles || y > map.heightInTiles) {
				return new FlxPoint( -1, -1);
			}
			
			//var tilewidth:Number = map.getTileWidth();
			//var tileheight:Number = map.getTileHeight();
			var tilewidth:Number = map.getTileWidthInPixels();
			var tileheight:Number = map.getTileHeightInPixels();
			
			return new FlxPoint( (tilewidth * x) + tilewidth / 2 - 1, tileheight * y + tileheight / 2 - 1);
		}
		
		public static function tilePtToMidpoint(map:Map, flxPoint:FlxPoint):FlxPoint {
			return tileToMidpoint(map, flxPoint.x, flxPoint.y);
		}
		
		public static function pointToTileCoords(map:Map, point:FlxPoint):FlxPoint {
			//var tilewidth:Number = map.getTileWidth();
			//var tileheight:Number = map.getTileHeight();
			var tilewidth:Number = map.getTileWidthInPixels();
			var tileheight:Number = map.getTileHeightInPixels();

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
		
		/**
		 * returns (1-x)^2*0xff
		 * @param	var x [0,1]
		 * @return [0x00,0xff]
		 */
		public static function xsqtimesff(x:Number):uint {
			return uint((1-x)*(1-x)*0xff);
		}
		
		/**
		 * 
		 * @param	var x [0,1]
		 * @return [0x00,0xff]
		 */
		public static function floorxtimesff(x:Number):uint {
			return uint(Math.floor(((1-x)*0xff)));
		}
		
		/**
		 * 
		 * @param	var x [0,1]
		 * @return
		 */
		public static function stepfunction(x:Number):uint {
			var intensity:Number = 0;
			
			if (x <= .1) {
				intensity = .9;
			}else if (x <=.2) {
				intensity = .9 + (.4 - .9) * ((x - .1) * 10);
			}else if (x <= .25) {
				intensity = .4 + (.75 - .4) * ((x - .2) * 20);
			}else if (x <= .35) {
				intensity = .75 + (.1 - .75) * ((x - .25) * 10);
			}else {
				intensity = .1 + (0 - .1) * ((x - .35) * 100/65);
			}
			
			return uint(intensity * 0xff);
		}
		
		/**
		 * 
		 * @param	x
		 * @return sample from N(x,1)*255, clamped to [0x00,0xff]
		 */
		public static var thesum:Number = 0;
		public static var count = 0;
		public static function samplenormal(x:Number):uint {
				/*var sample:Number = Math.sqrt( -2 * Math.log(Math.random()) / Math.E) * Math.cos(2 * Math.PI * Math.random());
				thesum += sample;
				*/
				
				var x:Number = 0;
				var y:Number = 0;
				var rds:Number;
				var c:Number;
								
				do{
				x = Math.random()*2-1;
				y = Math.random()*2-1;
				rds = x*x + y*y;
	
				}while (rds == 0 || rds > 1);
				
				c = Math.sqrt(-2*Math.log(rds)/Math.log(Math.E)*1/rds);
				var sample:Number = c * x;
				thesum += sample;
				sample /= (10*Math.min(x,0.5));
				sample += (1 - x);
				//trace(uint(Math.min(0xff, Math.max(0, sample*0xff))));
				count++;
				trace(thesum / count);
				return uint(Math.min(0xff, Math.max(0, sample*0xff)));
		}
		
		public static function sampleradial(x:Number):uint {
			var sample:Number = Math.random();
			var beta:Number = 55*x;
			sample = Math.exp(-beta * ((sample- .5) * (sample-.5)));
			var conditionalsample = Math.random();
			conditionalsample = Math.exp(-beta * ((conditionalsample- .5) * (conditionalsample-.5)));
			if(conditionalsample >=0.6){
				return uint(Math.min(0xff, Math.max(0, sample * 0xff)));
			}else {
				return 0x00;
			}
		}
	}

}