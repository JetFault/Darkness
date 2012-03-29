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
		private var controlScheme:int;
		
		public function PlayerController(player:Player, controlScheme:int) 
		{
			this.player = player;
			this.controlScheme = controlScheme;
		}
		
		override public function update():void {
			if (controlScheme == 1)
			{
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
					player.acceleration.y += player.drag.y;
				}
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					player.acceleration.y += -player.drag.y;
				}
			}
			if (controlScheme == 2)
			{
				player.velocity.x = 0;
				player.velocity.y = 0;
				
				if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					player.velocity.x += player.maxVelocity.x;
				}
				if (FlxG.keys.LEFT || FlxG.keys.A)
				{
					player.velocity.x += -player.maxVelocity.x;
				}
				if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					player.velocity.y += player.maxVelocity.y;
				}
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					player.velocity.y += -player.maxVelocity.y;
				}
			}
			if (controlScheme == 3)
			{
				
			}
			
			/*
			var velocityp:FlxPoint = new FlxPoint(player.velocity.x, player.velocity.y);
			var origin:FlxPoint = new FlxPoint(0, 0);
			player.angle = FlxU.getAngle(origin, velocityp);
			*/
			
			/*var p1:FlxPoint = new FlxPoint(player.x, player.y);
			var p2:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			player.angle = FlxU.getAngle(p1, p2);*/
			
			
			super.update();
		}
	}

}
