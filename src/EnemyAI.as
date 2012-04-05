package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
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
		protected var searching:Boolean;  //Is this guy doing a DFS?
		
		
		public function EnemyAI(self:Enemy, player:Player, map:Map) 
		{
			this.self = self;
			this.player = player;
			this.map = map;
			this.visible = false;
		}
		
		public function doNextAction():void {
			var playerPos:FlxPoint = this.player.getMidpoint();
			var enemyPos:FlxPoint = this.self.getMidpoint();
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			
			if (distance <= 60) {
				var thepath:FlxPath = this.map.findPath(this.self.getMidpoint(), this.player.getMidpoint());
				var howclose:Number = Utils.getPathDistance(thepath);
				if (thepath != null && howclose <= 60) {
					this.visible = true;
					this.searching = false;
				}else {
					this.visible = false;
					this.searching = true;
				}
				thepath.destroy();
				//this.searching = false;
			}
			
			if (!this.visible) {
				/*if (distance < 80) {
					this.visible = true;
					this.searching = false;
				}else {*/
					if (!searching) {
						currentindex = 0;
						closed = getAutoPath();
						currentPoint = Utils.tileToMidpoint(map, closed[currentindex][0], closed[currentindex][1]);	
						searching = true;
					}else {
						//Proceed to next part of DFS
						if(Utils.getDistance(currentPoint,self.getMidpoint()) < 10){
							currentindex += 1;
							currentindex %= closed.length;
							currentPoint = Utils.tileToMidpoint(map, closed[currentindex][0], closed[currentindex][1]);	
						}

						var enemyPath:FlxPath = this.map.findPath(self.getMidpoint(), currentPoint);
						if (enemyPath) {
							this.self.followPath(enemyPath, self.getEnemyRunSpeed());
						}
					}
				//}
			}else {
				enemyPath = this.map.findPath(self.getMidpoint(), player.getMidpoint());
				if (enemyPath == null) {
					trace("No Path found");
					this.self.stopFollowingPath(true);
				}
				else  {
					this.self.followPath(enemyPath, self.getEnemyRunSpeed());
				}
			}
		}
		
		protected function isPresent(array:Array, point:FlxPoint): Boolean {
			for each(var p:FlxPoint in array) {
				if (p.x == point.x && p.y == point.y) {
					return true;
				}
			}
			
			return false;
		}
		
		protected function getAutoPath():Array {
			return null;
		}
		
	}

}