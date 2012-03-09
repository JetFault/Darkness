package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	import org.flixel.*;
	public class PlayerController extends BaseController
	{
		private var player:Player;
		
		
		public function PlayerController(player:Player) 
		{
			this.player = player;
		}
		
		override public function update():void {
			player.acceleration.x = 0;
			player.acceleration.y = 0;
			
			if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				player.acceleration.x += player.drag.x;
			}
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{
				player.acceleration.x += -player.drag.x;
			}
			if (FlxG.keys.DOWN || FlxG.keys.S)
			{
				player.acceleration.y += player.drag.x;
			}
			if (FlxG.keys.UP || FlxG.keys. W)
			{
				player.acceleration.y += -player.drag.x;
			}
			
			var velocityp:FlxPoint = new FlxPoint(player.velocity.x, player.velocity.y);
			var origin:FlxPoint = new FlxPoint(0, 0);
			player.angle = FlxU.getAngle(origin, velocityp);
			
			super.update();
		}
	}

}