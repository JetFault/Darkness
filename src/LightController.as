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
		
		public var preVelocity:FlxPoint;
		public var deltaVel:FlxPoint;
		
		private var preChange:Number;
		private var LargeScale:Number = 1.0
		
		public function LightController(light:Light, player:Player) 
		{
			this.light = light;
			this.player = player;
			
			preVelocity = player.velocity;
			preChange = Utils.getDistance(new FlxPoint(0,0), player.maxVelocity);
		}
		
		override public function update():void {
			
			if (!player.playerHasItem(ItemType.LANTERN)) {
				LargeScale = 1.0;
			}else {
				LargeScale = 1.5;
			}
			light.lastchord.x = light.x-(player.x +4);
			light.lastchord.y = light.y - (player.y +5);
			var angle:Number = 0;
			var center:Boolean = false;
			var radius:Number = 7;
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
			
			//trace(player.deltaPosition.x);
			
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
			
			
			var zero:FlxPoint;
			zero = new FlxPoint(0, 0);
			//var change:Number = (40 - Utils.getDistance(zero, player.velocity)) * 0.0015 + 0.4;
			var change:Number = Utils.getDistance(zero, player.maxVelocity) - Utils.getDistance(zero, player.deltaPosition);
			var deltaChange:Number = change - preChange;
			var scaleValue:Number = Math.max(0, Math.min(LargeScale,(1.0 - Math.abs(deltaChange * 0.05) - (Math.random() * 0.2)) * LargeScale) -.1);
			if (!player.playerHasItem(ItemType.LANTERN)) {
				scaleValue = 1.0;
			}
			
			light.scale.x = scaleValue;
			light.scale.y = scaleValue;
						
			preChange = change;
			if (scaleValue < 0) {
				trace(scaleValue);
			}
			
			super.update();
		}
		
	}

}