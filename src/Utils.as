package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import de.polygonal.ds.Heap;
	import org.flixel.FlxSprite;
	import org.flixel.FlxGroup;

	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Utils 
	{
		
		public static function randInt( min : int, max : int ) : int {
			return int((Math.random() * (max - min + 1)) + min);
		}
		
		public static function isPath(level:Map, point1:FlxPoint, point2:FlxPoint):Boolean {
			if ( level.findPath(point1, point2, true, false) != null) {
				return true;
			}
			return false;
		}
		
		public static function getVolume(dis:Number, p1:FlxPoint, p2:FlxPoint):Number
		{
			var distance:Number = getDistance(p1, p2);
			
			var maxDis:Number = dis;
			var m:Number = -1 / maxDis;
			var b:Number = 1;
			var x:Number = distance;
			var y:Number = (m * x) + b;
			return y;
		}
		
		public static function getDistance(p1:FlxPoint, p2:FlxPoint):Number
		{
			var xDist:Number = p1.x - p2.x;
			var yDist:Number = p1.y - p2.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}
		
		public static function getPointThatCentersObject(map:Map, object:FlxSprite):FlxPoint
		{
			object.x = (object.x + (map.getTileWidthInPixels() /2)) - (object.width / 2);
			object.y = (object.y + (map.getTileHeightInPixels() / 2)) - (object.height / 2);
			var point:FlxPoint = new FlxPoint(object.x, object.y);
			return point;
		}
		
		//Assumes only FlxSprites in g
		public static function getMinDistance(p:FlxPoint, g:FlxGroup):Number {
			var distance:Number = Number.POSITIVE_INFINITY;
			for (var i:uint = 0; i < g.members.length; i++) {
				var spr:FlxSprite = g.members[i] as FlxSprite;
				if (!spr || !spr.alive) {
					continue;
				}
				distance = Math.min(distance, Utils.getDistance(p, spr.getMidpoint()));
			}
			return distance;
		}
		
		//Assumes only FlxSprites in g
		public static function getMaxDistance(p:FlxPoint, g:FlxGroup):Number {
			var distance:Number = Number.NEGATIVE_INFINITY;	
			for (var i:uint = 0; i < g.members.length; i++) {
				var spr:FlxSprite = g.members[i] as FlxSprite;
				if (!spr || !spr.alive) {
					continue;
				}
				distance = Math.max(distance, Utils.getDistance(p, spr.getMidpoint()));
			}
			return distance;
		}
		
		//not sure this works properly
		public static function getPathDistance(path:FlxPath):Number
		{
			var distance:Number = 0;
			
			if (path == null) return 0;
			
			for (var i:int = 0; i < path.nodes.length - 1; i++)
			{
				distance += getDistance(path.nodes[i], path.nodes[i + 1]);
			}
			return distance;
		}
		
		/**
		 * Tile-to-pixel (and vice versa) functions below
		 */
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
		
		/**
		 * Changes world coordinates to maze coordinates
		 * @param	map
		 * @param	point
		 * @return
		 */
		public static function pointToTileCoords(map:Map, point:FlxPoint):FlxPoint {
			var tilewidth:Number = map.getTileWidthInPixels();
			var tileheight:Number = map.getTileHeightInPixels();
			if (point.x < 0 || point.y < 0 || point.x>= map.widthInTiles*tilewidth|| point.y > map.heightInTiles*tileheight) {
				return new FlxPoint(-1,-1);
			}
			return new FlxPoint(Math.floor(point.x / tilewidth), Math.floor(point.y / tileheight));
		}
		
		
		/**
		 * Begin AI Path functions
		 */
		/**
		 * 
		 * @param	map
		 * @param	depth
		 * @param	enemy
		 * @return
		 */
		public static function createDFSPath(map:Map, depth:Number, enemypoint:FlxPoint):Array {
			
			//Initialization
			var starttile:FlxPoint = Utils.pointToTileCoords(map, enemypoint);
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
	
				
				//Base case: depth
				if (node[2] >= depth) {
					continue;
				}
					
				//Base case: Node has already been visited
				if (Utils.inArray(closed, node)) {
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
						
						var p3:Array = new Array(0,0,0);
						p3[0] = node[0] + dx;
						p3[1] = node[1] + dy;
						p3[2] = node[2] + 1;
						
						//If not empty point in maze, skip
						if (map.getTile(p3[0], p3[1]) != Constants.EMPTYTILEINDEX ) {
							continue;
						}
						
						//If not in closed, push it to frontier
						if (!Utils.inArray(closed, p3)) {
							frontier.push(p3);
						}
					}
				}
				
			}
			return closed;
		}
		
		/**
		 * Begin AI Path functions
		 */
		/**
		 * 
		 * @param	map
		 * @param	depth
		 * @param	enemy
		 * @return
		 */
		public static function createUCSPath(map:Map, depth:Number, enemypoint:FlxPoint, player:Player):Array {
			
			//Initialization
			var starttile:FlxPoint = Utils.pointToTileCoords(map, enemypoint);
			var root:HeapItem = new HeapItem(map, player.getMidpoint(), new FlxPoint(starttile.x, starttile.y), 0, 0);	
			
			var closed:Array = new Array();			
			var frontier:Heap = new Heap();
			var frontierArray:Array = new Array();
			frontier.add(root);
			frontierArray.push(root);
			var numnodes:uint = 0;
			
			
			//UCS loop
			while (frontier.size() > 0) {
				//Get next node on frontier
				var node:HeapItem = frontier.pop() as HeapItem;
				numnodes++;
				var newarray:Array = new Array();
				for (var index:uint = 0; index < frontierArray.length; index++) {
					var theitem:HeapItem = frontierArray[index] as HeapItem;
					if (theitem != node) {
						newarray.push(theitem);
					}
				}
				frontierArray = newarray;

				
				/*
				 * TODO:  EITHER BASE CASE BY DEPTH OR BY DISTANCE 
				 */
				//Base case: depth
				if (numnodes >= depth) {
					//trace("NUMNODES");
					//trace(numnodes);
					break;
				}
					
				//Base case: Node has already been visited
				if (Utils.heapItemInArray(closed, node)) {
					continue;
				}
					
				//Node has not been visited.  Push to closed	
				closed.push(node);
				//trace("CLOSED");
				//trace(closed);
				//Get neighbors
				for each(var dx:Number in new Array( -1, 0, 1)) {
					for each(var dy:Number in new Array( -1, 0, 1)) {
						/*if (dx != 0 && dy != 0) {
							continue;
						}*/
						
						var newp:HeapItem = new HeapItem(map, player.getMidpoint(), new FlxPoint(node.getTileLocation().x + dx, node.getTileLocation().y + dy), node.getDepth() + 1, node.value);
						//var p3:Array = new Array(0,0,0);
						//p3[0] = node[0] + dx;
						//p3[1] = node[1] + dy;
						//p3[2] = node[2] + 1;
						
						//If not empty point in maze, skip
						if (map.getTile(newp.getTileLocation().x, newp.getTileLocation().y) != Constants.EMPTYTILEINDEX ) {
							continue;
						}
						
						//If not in closed, push it to frontier (if never seen) or replace "equivalent" point that is closer to the player
						if (!Utils.heapItemInArray(closed, newp)) {
							if (!Utils.heapItemInArray(frontierArray, newp)) {
								frontier.add(newp);
								frontierArray.push(newp);
							}else {
								var otherp:HeapItem = Utils.getEquivalentItemFromArray(frontierArray, newp);
								//If newp has higher priority (i.e. is more distant), replace otherp.  Otherwise, ignore newp
								if (newp.compare(otherp) < 0) {
									frontier.remove(otherp);
									var na:Array = new Array();
									for (var index:uint = 0; index < frontierArray.length; index++) {
										var theitem:HeapItem = frontierArray[index] as HeapItem;
										if (theitem != otherp) {
											na.push(theitem);
										}
									}
									frontierArray = na;
									frontier.add(newp);
									frontierArray.push(newp);
								}
							}
						}
					}
				}
				
			}
			
			var closedarrayofarrays:Array = new Array();
			for (var index:uint = 0; index < closed.length; index++) {
				var theitem:HeapItem = closed[index] as HeapItem;
				closedarrayofarrays.push(new Array(theitem.getTileLocation().x, theitem.getTileLocation().y, theitem.getDepth()));
			}
			//trace("DONE UCS");
			//trace(closedarrayofarrays);
			return closedarrayofarrays;
		}
		
		/**
		 * 
		 * @param	map
		 * @param	depth
		 * @param	enemy
		 * @return
		 */
		public static function randomDFS(map:Map, depth:Number, enemypoint:FlxPoint):Array {
			var p:FlxPoint = Utils.pointToTileCoords(map, enemypoint);
			while (true) {
				var tilex:uint = p.x + uint(samplegauss(0, 5));
				var tiley:uint = p.y + uint(samplegauss(0, 5));
				if (tilex >= 0 && tilex < map.getMapWidthInTiles() && 
					tiley >= 0 && tiley < map.getMapHeightInTiles() &&
					map.getTile(tilex, tiley) == Constants.EMPTYTILEINDEX) {
						var a:Array = createDFSPath(map, depth, Utils.tilePtToMidpoint(map, new FlxPoint(tilex, tiley)));
						a = a.reverse();
						a.push(new Array(p.x, p.y, 0));
						a = a.reverse();
						return a;
					}
			}
			
			return null;
		}
		
		
		private static function inArray(array:Array, arr2:Array): Boolean {
			for each(var p:Array in array) {
				if (p[0] == arr2[0] && p[1] == arr2[1]) {
					return true;
				}
			}
			return false;
		}
		
		private static function heapItemInArray(array:Array, item:HeapItem):Boolean {
			for (var i:uint = 0; i < array.length; i++ ) {
				if (item.equals(array[i] as HeapItem)) {
					return true;
				}
			}
			return false;
		}
		
		private static function getEquivalentItemFromArray(array:Array, item:HeapItem):HeapItem {
			for (var i:uint = 0; i < array.length; i++ ) {
				if (item.equals(array[i] as HeapItem)) {
					return array[i] as HeapItem;
				}
			}
			return null;
		}
		
		
		
		/**
		 * Sequential lightning functions below
		 */
		/**
		 * returns (1-x)^2*0xff
		 * @param	var x [0,1]
		 * @return [0x00,0xff]
		 */
		public static function xsqtimesff(x:Number):uint {
			return uint((1-x)*(1-x)*0xff);
		}
		
		/**
		 * "linearly interpolates" from 255 to 0
		 * @param	var x [0,1]
		 * @return [0x00,0xff]
		 */
		public static function floorxtimesff(x:Number):uint {
			return uint(Math.floor(((1-x)*0xff)));
		}
		
		/**
		 * Approximation of a mixture of 2 gaussian-like functions
		 * Large maximum in beginning, smaller maximum later, slow degrade at end.
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
				intensity = .4 + (.6 - .4) * ((x - .2) * 20);
			}else if (x <= .35) {
				intensity = .6 + (.1 - .6) * ((x - .25) * 10);
			}else {
				intensity = .1 + (0 - .1) * ((x - .35) * 100/65);
			}
			
			return uint(intensity * 0xff);
		}
		
		/**
		 * Get value [0,1] from radial with maximum @ 0.
		 * @param	x
		 * @return
		 */
		public static function sampleradial(beta:Number):Number {
			var sample:Number = Math.random();
			sample = Math.exp( -beta * ((sample- .5) * (sample-.5)));
			return sample;
		}
		
		
		/**
		 * Sample from a gaussian with unit mean and 0 standard deviation
		 * WARNING:  Not clamped to range[0x00,0xff]
		 * @param	mean
		 * @param	std
		 * @return sample.  Not clamped to range[0x00,0xff]
		 */
		public static function samplegauss(mean:Number = 0,std:Number=1):Number {
				
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
				var sample:Number = c * y;
				sample *= std;
				sample += mean;
				return sample;
		}
		

		
		/**
		 * Step function with some gaussian noise.  Noise has 0 mean and .1 std
		 * @param	x
		 * @return
		 */
		public static function stepwithgauss(x:Number):uint {
			return uint(Math.min(0xff, Math.max(0, Utils.stepfunction(x) + 0xff * Utils.samplegauss(0, .1))));
		}
		
		
		/**
		 * Batch lightning algorithms below
		 */
		/**
		 * Brownian motion with size = 2^(size)+1 for given nonnegative size.
		 * @param	size
		 * @return
		 */
		public static function brownian(size:Number=3):Array {
			var retarr:Array = new Array();
			
			var first:uint = uint(Math.min(0xff, 0xdf + samplegauss(0,1)));
			var last:uint = uint(Math.max(0, 0 + samplegauss(0, 1)));

			retarr.push(first);
			while (retarr.length < size) {
				retarr.push(0);
			}
			retarr.pop();
			retarr.push(last);
			brownian_helper(0, size-1, retarr, 0);
			return retarr;
		}
		
		/**
		 * Recurses through array computed through brownian motion
		 * @param	firstindex
		 * @param	lastindex
		 * @param	thearray
		 * @param	iterationnum
		 */
		private static function brownian_helper(firstindex:uint, lastindex:uint, thearray:Array, iterationnum:Number):void {
			var someconstant:Number = 1;
			if (lastindex - firstindex <= 1) {
				return;
			}
			
			var midindex:uint = (firstindex+lastindex) / 2;
			var midval:Number = (thearray[firstindex] + thearray[lastindex]) / 2;
			
			thearray[midindex] = uint(Math.min(0xff,Math.max(0, midval + 0xff*samplegauss(0,.5*Math.pow(0.5,iterationnum)))));
			//thearray[midindex] = uint(Math.min(0xff,Math.max(0, midval + 0xff*samplegauss(0,0.5*Math.pow(0.9,iterationnum)))));
			
			brownian_helper(firstindex, midindex, thearray, iterationnum + 1);
			brownian_helper(midindex, lastindex, thearray, iterationnum + 1);
		}
		
		public static function inverseeuclidean(p1:FlxPoint, p2:FlxPoint, coefficient:Number):Number {
			return coefficient / Utils.getDistance(p1, p2);
		}
		
		public static function sign(x:Number):Number {
			if (x > 0)
				return 1;
			if (x < 0)
				return -1;
			return 0;
		}
		
		public static function hill(x:Number):Number {
			if (x < 0.33) {
				return Math.min(1,x/.33);
			}else if (x >= .33 && x < .66) {
				return 1;
			}else {
				return Math.max(0,1-(x-.66)/.33);
			}
			return 0;
		}
	}

}


/**
		 * Sample from normal distribution with shrinking standard deviation and decreasing mean.
		 * Linearly shrinks over time [0,1]
		 * @param	x
		 * @return sample from N(x,1)*255, clamped to [0x00,0xff]
		 
		public static function sampleshiftingnormal(time:Number):uint {		
				return uint(Math.min(0xff, Math.max(0, samplegauss(1-time,1/(10*Math.min(time,0.5)))*0xff)))
		}
		
		/**
		 * Sample from an RBF whose radius decreases over time [0,1].  Return sample with a probability.  Otherwise return 0
		 * @param	x
		 * @return
		 
		public static function sampleshrinkingradial(x:Number):uint {
			var sample:Number = Math.random();
			var beta:Number = 100 * x;
			sample = Math.exp( -beta * ((sample- .5) * (sample-.5)));// / Math.sqrt(2 * Math.PI * 1 / beta);
			
			if (thresholdshrinkingradial(0.6,beta)) {
				return uint(Math.min(0xff, Math.max(0, sample * 0xff)));
			}else {
				return 0x00;
			}
		}
		
		/**
		 * Sample from an RBF with given radius and return whether result is over given threshold.
		 * @param	beta
		 * @return
		 
		public static function thresholdshrinkingradial(threshold:Number, beta:Number):Boolean {
			var sample:Number = Math.random();
			sample = Math.exp( -beta * ((sample- .5) * (sample-.5)));// / Math.sqrt(2 * Math.PI * 1 / beta);
			return sample >= threshold;
		}
		
		
		
		/**
		 * No idea...
		 * @param	x
		 * @return
		 
		public static function sampleradialplusdecrease(x:Number):uint {
			var sample:uint = sampleshrinkingradial(x);
			if (x <= .7) {
				return sample;
			}else {
				return uint(Math.max(0, ((1 - x) * 0xff) +  0xff * ((sampleshrinkingradial(1-x*x) / 0xff - .5) * (1 - x))));
			}
		}*/
		
				/**
		 * Sample from a gaussian with 0 mean.
		 * @param	x
		 * @return
		 
		public static function samplegausszeromean(time:Number):uint {
			var sample:Number = samplegauss(0, 10*time);
			sample *= (1 - time);
			return uint(0xff*sample);
		}
		
		
		public static function radialagain(x:Number):uint {
			return uint(2*(1-x)*sampleshrinkingradial(1 - x));
		}*/
