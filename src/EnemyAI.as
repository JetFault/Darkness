package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class EnemyAI 
	{
		protected var self:Enemy;
		protected var player:Player;
		protected var map:Map;
		protected var visible:Boolean; //Is the player visible?
		public function EnemyAI(self:Enemy, player:Player, map:Map) 
		{
			this.self = self;
			this.player = player;
			this.map = map;
			this.visible = false;
		}
		
		public function doNextAction():void {
			
		}
		
	}

}