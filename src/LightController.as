package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
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
			light.lastchord.x = light.x-(player.x +4);
			light.lastchord.y = light.y - (player.y +5);
			var angle:Number = 0;
			var center:Boolean = false;
			var radius:Number = 10;
			if (Utils.sign(player.velocity.x)> 0 && Utils.sign(player.velocity.y) > 0) {
				angle = 45;
			}else if (Utils.sign(player.velocity.x)> 0 && Utils.sign(player.velocity.y) == 0) {
				angle = 0;
			}else if (Utils.sign(player.velocity.x)> 0 && Utils.sign(player.velocity.y) < 0) {
				angle = 315;
			}else if (Utils.sign(player.velocity.x)< 0 && Utils.sign(player.velocity.y) > 0) {
				angle = 135;
			}else if (Utils.sign(player.velocity.x) < 0 && Utils.sign(player.velocity.y) == 0) {
				angle = 180;
			}else if (Utils.sign(player.velocity.x) < 0 && Utils.sign(player.velocity.y) < 0) {
				angle = 225;
			}else if (Utils.sign(player.velocity.x)== 0 && Utils.sign(player.velocity.y) > 0) {
				angle = 90;
			}else if (Utils.sign(player.velocity.x) == 0 && Utils.sign(player.velocity.y) < 0) {
				angle = 270;
			}else {
				center = true;
			}
			
			angle *= Math.PI / 180;
			light.x = player.x + 4 + light.lastchord.x;
			light.y = player.y + 5 + light.lastchord.y;
			
			
			
			if (!center) {
				light.x += ((player.x + 4 + radius * Math.cos(angle)) - light.x) / 20;
				light.y +=  ((player.y + 5 + radius * Math.sin(angle)) - light.y) / 20;
				light.velocity.x =  (player.x + 4 + radius * Math.cos(angle))-light.x;
				light.velocity.y =  (player.y + 5 + radius * Math.sin(angle))-light.y;
			}else {
				light.x += ((player.x + 4)-light.x) / 10;
				light.y +=  ((player.y + 5)-light.y) / 10;
				light.velocity.x =  (player.x + 4)-light.x;
				light.velocity.y =  (player.y + 5)-light.y;
			}
			
			light.velocity.x *= 20;
			light.velocity.y *= 20;
			
			
			
			
			super.update();
		}
		
	}

}