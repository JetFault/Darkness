package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class UCSSearchAI extends EnemyAI 
	{
		
		private var root:Array;
		
		public function UCSSearchAI(self:Enemy,player:Player, map:Map) 
		{
			depth = 50;  //WARNING:  DEPTH HERE MEANS SOMETHING DIFFERENT IN DFS...OOPS.  Bad coding...
			super(self, player, map);
			this.xpos = 30;
			this.ypos = 2;
		}
		
		override protected function getAutoPath():Array {
			return Utils.createUCSPath(map, depth, self, player);
		}
		
	}

}