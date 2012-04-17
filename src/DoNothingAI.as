package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class DoNothingAI extends EnemyAI 
	{
		
		public function DoNothingAI(enemy:Enemy, player:Player, map:Map, onpathcompletion:String, depth:Number)
		{
			super(self, player, map, onpathcompletion, depth);
		}
		
		override public function doNextAction():void {
			return;
		}
		
	}

}