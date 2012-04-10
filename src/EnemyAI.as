package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
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
		protected var visibledistance:Number = 100;
		protected var depth:Number = 50;
		
		
		public function EnemyAI(self:Enemy, player:Player, map:Map) 
		{
			this.self = self;
			this.player = player;
			this.map = map;
			this.visible = false;
			/*if (FlxG.level > 0) {
				this.depth *= FlxG.level;
			}*/
		}
		
		public function doNextAction():void {
			var playerPos:FlxPoint = this.player.getMidpoint();
			var enemyPos:FlxPoint = this.self.getMidpoint();
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			
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
			var thepath:FlxPath = this.map.findPath(this.self.getMidpoint(), this.player.getMidpoint());
			if (thepath != null && Utils.getPathDistance(thepath) >= visibledistance) {
				this.visible = false;
			}
			if (thepath) {
				thepath.destroy();
			}
			
			//If found, just follow.  Else, go around predetermined path
			if (!this.visible) {
				/*if (distance < 80) {
					this.visible = true;
					this.pathcreated = false;
				}else {*/
					if (!pathcreated) {
						currentindex = 0;
						closed = getAutoPath();
						currentPoint = Utils.tileToMidpoint(map, closed[currentindex][0], closed[currentindex][1]);	
						pathcreated = true;
					}else {
						//Proceed to next part of DFS
						if(Utils.getDistance(currentPoint,self.getMidpoint()) < 5){
							currentindex += 1;
							currentindex %= closed.length;
							currentPoint = Utils.tileToMidpoint(map, closed[currentindex][0], closed[currentindex][1]);	
						}
						
						if (enemyPath) {
							enemyPath.destroy();
						}
						enemyPath = this.map.findPath(self.getMidpoint(), currentPoint);
						if (enemyPath) {
							this.self.followPath(enemyPath, self.getEnemyRunSpeed());
						}
					}
				//}
			}else {
				//Clean up last path
				if (enemyPath) {
					enemyPath.destroy();
				}
				//Find a new path between self and player
				enemyPath = this.map.findPath(self.getMidpoint(), player.getMidpoint());
				//If no path found, just sit still for that frame.  Otherwise, follow the path.
				if (enemyPath == null) {
					trace("No Path found");
					this.self.stopFollowingPath(true);
				}
				else  {
					this.self.followPath(enemyPath, self.getEnemyRunSpeed());
				}
			}
		}
		
		protected function getAutoPath():Array {
			return null;
		}
		
		public function setPlayerVisible():void {
			var thepath:FlxPath = this.map.findPath(this.self.getMidpoint(), this.player.getMidpoint());
			if (thepath != null && Utils.getPathDistance(thepath) <= visibledistance) {
				this.visible = true;
			}else {
				this.visible = false;
			}
			if (thepath) {
				thepath.destroy();
			}
		}
		
	}

}