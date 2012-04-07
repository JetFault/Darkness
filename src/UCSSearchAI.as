package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class UCSSearchAI extends EnemyAI 
	{
		
		private var depth:Number; //Ideally variable?
		private var root:Array;
		
		public function UCSSearchAI(self:Enemy,player:Player, map:Map) 
		{
			super(self, player, map);
			depth = 50;  //WARNING:  DEPTH HERE MEANS SOMETHING DIFFERENT IN DFS...OOPS.  Bad coding...
			this.xpos = 30;
			this.ypos = 2;
		}
		
		override protected function getAutoPath():Array {
			return Utils.createUCSPath(map, depth, self, player);
		}
		
	}

}