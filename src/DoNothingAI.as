package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class DoNothingAI extends EnemyAI 
	{
		
		public function DoNothingAI(enemy:Enemy, player:Player, map:Map)
		{
			super(self, player, map);
		}
		
		override public function doNextAction():void {
			return;
		}
		
	}

}