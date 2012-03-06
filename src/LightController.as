package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class LightController extends BaseController
	{
		private var light:Light;
		private var player:Player;
		public function LightController(light:Light, player:Player) 
		{
			this.light = light;
			this.player = player;
		}
		
		override public function update():void {
			light.x = player.x + 4;
			light.y = player.y + 5;
			super.update();
		}
		
	}

}