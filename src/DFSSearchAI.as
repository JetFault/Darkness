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
		private var root:Array;
		
		public function DFSSearchAI(self:Enemy,player:Player, map:Map) 
		{
			depth = 20;
			super(self, player, map);
			this.xpos = 30;
			this.ypos = 2;
		}
		
		override protected function getAutoPath():Array {
			return Utils.createDFSPath(map, depth, self);
		}
	}

}

/* Begin Python Code
 
def genericSearch(problem, frontier):
    closed = set()
    frontier.push(SearchNode(problem.getStartState()))
    while not frontier.isEmpty():
        N = frontier.pop()
        if N.state in closed:
            continue
        if problem.isGoalState(N.state):
            return N.path()
        closed.add(N.state)
        for (state, action, step_cost) in problem.getSuccessors(N.state):
            if state not in closed:
                frontier.push(SearchNode(state, N, action, step_cost))
    return list()
	//end python code
*/	
	
/* Create DFS tree
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
}
*/