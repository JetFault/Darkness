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
			
			if (FlxG.keys.justPressed("SPACE")) {
				light.toggledraw();
			}
			
			//TODO:  Proper transformations.  Also make angle sensitive to mouse location.
			light.angle = player.angle;
			
			light.x = player.x + 4;
			light.y = player.y + 5;
			super.update();
		}
		
	}

}