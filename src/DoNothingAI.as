package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class DoNothingAI extends EnemyAI 
	{
		
		public function DoNothingAI(enemy:Enemy, player:Player, map:Map, onpathcompletion:String)
		{
			super(self, player, map, onpathcompletion);
		}
		
		override public function doNextAction():void {
			return;
		}
		
	}

}