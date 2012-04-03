package  
{
	//import de.polygonal.ds.TreeNode;
	import flash.geom.Point;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
	//import de.polygonal.ds.TreeBuilder;
	//import de.polygonal.ds.TreeIterator;
	//import de.polygonal.ds.TreeNode;
	//import de.polygonal.ds.DLL;
	//import de.polygonal.ds.DLLNode;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class DFSSearchAI extends EnemyAI 
	{
		private var depth:Number; //Ideally variable?
		private var searching:Boolean;  //Is this guy doing a DFS?
		private var xpos:Number; //x position on map in tiles (not in pixels)
		private var ypos:Number; //y position on map in tiles (not in pixels)
		private var root:Array;
		private var currentindex:Number;
		private var closed:Array;
		private var enemyPath:FlxPath;
		private var currentPoint:FlxPoint = new FlxPoint(0,0);
		
		public function DFSSearchAI(self:Enemy,player:Player, map:Map) 
		{
			super(self, player, map);
			depth = 20;
			this.xpos = 30;
			this.ypos = 2;
		}
		
		override public function doNextAction():void {
			var playerPos:FlxPoint = this.player.getMidpoint();
			var enemyPos:FlxPoint = this.self.getMidpoint();
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			
			if (distance > 60) {
				this.visible = false;
				//this.searching = false;
			}
			
			if (!this.visible) {
				if (distance < 80) {
					this.visible = true;
					this.searching = false;
				}else {
					if (!searching) {
						currentindex = 0;
						closed = Utils.createDFSPath(map, depth, self);
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
				}
			}else {
				enemyPath = this.map.findPath(self.getMidpoint(), player.getMidpoint());
				this.self.followPath(enemyPath, self.getEnemyRunSpeed());
			}
		}
		
		
		private function isPresent(array:Array, point:FlxPoint): Boolean {
			for each(var p:FlxPoint in array) {
				if (p.x == point.x && p.y == point.y) {
					return true;
				}
			}
			
			return false;
		}
	}

}

						//begin python code 
//def genericSearch(problem, frontier):
//    closed = set()
//    frontier.push(SearchNode(problem.getStartState()))
//    while not frontier.isEmpty():
//        N = frontier.pop()
//        if N.state in closed:
//            continue
//        if problem.isGoalState(N.state):
//            return N.path()
//        closed.add(N.state)
//        for (state, action, step_cost) in problem.getSuccessors(N.state):
//            if state not in closed:
//                frontier.push(SearchNode(state, N, action, step_cost))
//    return list()
	//end python code
	
	/*//Create DFS tree
						root = new Array(0,0,0);
						root[0] = self.getMidpoint().x;
						root[1] = self.getMidpoint().y;
						root[2] = 0;
						currentindex = 0;
						
						closed = Array(0);
						var frontier:Array = Array(0);
						closed.pop();
						frontier.pop();
						frontier.push(root);
						while (frontier.length > 0) {
							frontier = frontier.reverse();
							var node:Array = frontier.pop();
							frontier = frontier.reverse();
							var inclosed:Boolean = false;
							
							if (node[2] >= depth) {
								continue;
							}
							for each (var elem:Array in closed) {
								if (elem[0] == node[0] && elem[1] == node[1]) {
									inclosed = true;
									break;
								}
							}
							if (inclosed) {
								continue;
							}
							closed.push(node);
							
							for each(var dx:Number in new Array( -1, 1)) {
								for each(var dy:Number in new Array( -1, 1)) {
									var alsoinclosed:Boolean = false;
									var p3:Array = new Array(0,0,0);
									p3[0] = node[0] + dx;
									p3[1] = node[1] + dy;
									p3[2] = node[2] + 1;
									
									for each (var elem:Array in closed) {
										if (elem[0] == p3[0] && elem[1] == p3[1]) {
											alsoinclosed = true;
											break;
										}
									}
									if (!alsoinclosed) {
										frontier.push(p3);
									}
								}
							}
						}*/