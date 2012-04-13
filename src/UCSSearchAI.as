package  
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class UCSSearchAI extends EnemyAI 
	{
		
		private var root:Array;
		
		public function UCSSearchAI(self:Enemy,player:Player, map:Map, onpathcompletion:String) 
		{
			  //WARNING:  DEPTH HERE MEANS SOMETHING DIFFERENT IN DFS...OOPS.  Bad coding...
			super(self, player, map, onpathcompletion);
			this.xpos = 30;
			this.ypos = 2;
			this.depth = 2;
		}
		
		override protected function getAutoPath(currentpoint:FlxPoint):Array {
			return Utils.createUCSPath(map, depth, currentpoint, player);
		}
		
	}

}