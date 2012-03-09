package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxPoint;
	public class FlashLightController extends BaseController
	{
		private var light:FlashLight;
		private var player:Player;
		public function FlashLightController(light:FlashLight, player:Player) 
		{
			FlxG.mouse.show();
			this.light = light;
			this.player = player;
		}
		
		override public function update():void {
			
			if (FlxG.mouse.justPressed()) {
				light.toggledraw();
			}
			

			var p1:FlxPoint = new FlxPoint(player.x, player.y);
			var p2:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			light.angle = FlxU.getAngle(p1, p2);
			
			light.x = player.x;
			light.y = player.y - light.height/2;
			
			
			super.update();
		}
		
	}

}