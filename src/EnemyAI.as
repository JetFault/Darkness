package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class EnemyAI 
	{
		protected var self:Enemy;
		protected var player:Player;
		protected var map:Map;
		public var visible:Boolean; //Is the player visible?
		protected var xpos:Number; //x position on map in tiles (not in pixels)
		protected var ypos:Number; //y position on map in tiles (not in pixels)
		protected var currentindex:Number;
		protected var closed:Array;
		protected var enemyPath:FlxPath;
		protected var currentPoint:FlxPoint = new FlxPoint(0, 0);
		protected var pathcreated:Boolean;  //Is this guy doing a tree search?
		protected var visibledistance:Number = 30;
		protected var losesightdistance:Number = 100;
		protected var depth:Number = 50;
		protected var time:Number = 1;
		protected var timer:Number = 0;
		protected var onpathcompletion:String = null;
		protected var followingpath:Boolean = false;
		protected var lostsight:Boolean = false;
		
		
		public function EnemyAI(self:Enemy, player:Player, map:Map, onpathcompletion:String="loop", depth:Number = 50) 
		{
			this.self = self;
			this.player = player;
			this.map = map;
			this.visible = false;
			this.depth = depth;
			/*if (FlxG.level > 0) {
				this.depth *= FlxG.level;
			}*/
			this.onpathcompletion = onpathcompletion; //Values {"loop", "fromcurrentposition"}
		}
		
		public function doNextAction():void {
			var playerPos:FlxPoint = this.player.getMidpoint();
			var enemyPos:FlxPoint = this.self.getHitbox().getMidpoint();
			var distance:Number = Utils.getDistance(playerPos, enemyPos);
			
			
			//var xDist:Number = playerPos.x - enemyPos.x;
			//var yDist:Number = playerPos.y - enemyPos.y;
			//var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			
			//Check visibility
			/*if (distance <= visibledistance) {
				var thepath:FlxPath = this.map.findPath(this.self.getMidpoint(), this.player.getMidpoint());
				if (thepath != null && Utils.getPathDistance(thepath) <= visibledistance) {
					this.visible = true;
				}else {
					this.visible = false;
				}
				if (thepath) {
					thepath.destroy();
				}
			}*/
			
			
			//Lose sight of player if too far
			setPlayerVisible(visible);
			
			//If found, just follow.  Else, go around predetermined path
			if (!this.visible) {
				//FlxObject.PATH_LOOP_FORWARD FlxObject.PATH_YOYO
				/*if (distance < 80) {
					this.visible = true;
					this.pathcreated = false;
				}else {*/
					if (!pathcreated) {
						currentindex = 0;
						if (this.onpathcompletion == "loop") {
							closed = getAutoPath(self.getOriginalPosition());
							closed = closed.reverse();
							var p:FlxPoint = Utils.pointToTileCoords(map, self.getHitbox().getMidpoint());
							var a:Array = new Array(p.x,p.y);
							closed.push(a);
							closed = closed.reverse();
						}else if (this.onpathcompletion == "fromcurrentposition") {
							closed = getAutoPath(self.getHitbox().getMidpoint());
						}
						//currentPoint = Utils.tileToMidpoint(map, closed[currentindex][0], closed[currentindex][1]);	
						enemyPath = new FlxPath();
						for (var i:uint = 0; i < closed.length; i++) {
							closed[i] = Utils.tileToMidpoint(map, closed[i][0], closed[i][1]);
						}
						
						for (var i:uint = 0; i < closed.length - 1; i++) {
							var p1:FlxPoint = closed[i] as FlxPoint;
							var p2:FlxPoint = closed[i + 1] as FlxPoint;
							var temppath:FlxPath = this.map.findPath(p1, p2);
							while (temppath.nodes.length > 0) {
								enemyPath.addPoint(temppath.removeAt(0));
							}
							if(temppath){
								temppath.destroy();
							}
						}
						this.self.getHitbox().followPath(enemyPath, self.getEnemyRunSpeed(), FlxObject.PATH_FORWARD);
						pathcreated = true;
					}else {
						if (enemyPath && lostsight && enemyPath.nodes.length > 0) {
							this.self.getHitbox().followPath(enemyPath, this.self.getEnemyRunSpeed());
							lostsight = false;
						}
						
						if (enemyPath && Utils.getDistance(self.getHitbox().getMidpoint(), enemyPath.head()) < 5) {							enemyPath.removeAt(0);
							if (enemyPath.nodes.length == 0) {
								this.self.getHitbox().stopFollowingPath(true);
								enemyPath == null;
								pathcreated = false;
							}
						}
						
						//this.self.getHitbox().followPath(enemyPath, self.getEnemyRunSpeed(), FlxObject.PATH_LOOP_FORWARD);
						//pathcreated = true;
						/*
						//Proceed to next part of precomputed array
						if(Utils.getDistance(currentPoint,enemyPos) < 5){
							currentindex += 1;
							trace(currentindex);
							trace(closed.length);
							if (currentindex == closed.length) {
								pathcreated = false;
								return;
							}
							currentindex %= closed.length;
							currentPoint = Utils.tileToMidpoint(map, closed[currentindex][0], closed[currentindex][1]);	
						}
						
						//TODO:  Pathfinding optimization.  Try not to pathfind per frame.
						//Note:  enemy sprites making this difficult, since too large and must go through walls.  Try to make the hitbox pathfollow instead.
						if (enemyPath) {
							enemyPath.destroy();
						}
						enemyPath = this.map.findPath(enemyPos, currentPoint);
						if (enemyPath) {
							this.self.getHitbox().followPath(enemyPath, self.getEnemyRunSpeed());
						}
						*/
						//}
					}
				//}
			}else {
				//Clean up last path
				if (enemyPath) {
					enemyPath.destroy();
				}
				//Find a new path between self and player
				enemyPath = this.map.findPath(enemyPos, playerPos);
				//If no path found, just sit still for that frame.  Otherwise, follow the path.
				if (enemyPath == null) {
					//trace("No Path found");
					this.self.getHitbox().stopFollowingPath(true);
				}
				else  {
					this.self.getHitbox().followPath(enemyPath, self.getEnemyRunSpeed());
				}
			}
		}
		
		protected function getAutoPath(currentpoint:FlxPoint):Array {
			return null;
		}
		
		public function setPlayerVisible(isvisible:Boolean):void {
			
			
			var thepath:FlxPath = this.map.findPath(this.self.getMidpoint(), this.player.getMidpoint());
			var metric:Number = 0;
			if (isvisible) {
				metric = losesightdistance;
			}else {
				var hearingdistance:Number = Utils.getDistance(new FlxPoint(0, 0), this.player.getHitbox().velocity);
				metric = Math.min(losesightdistance*4/5, visibledistance + hearingdistance);
			}
			if (thepath && Utils.getPathDistance(thepath) <= metric) {
				this.visible = true;
				}else {
					this.visible = false;
					this.lostsight = true;
				}
				if (thepath) {
					thepath.destroy();
				}
			}
		
		
	}

}