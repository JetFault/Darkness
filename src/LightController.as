package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	public class LightController extends BaseController
	{
		private var light:Light;
		private var player:Player;
		
		public var preVelocity:FlxPoint;
		public var deltaVel:FlxPoint;
		
		private var preChange:Number;
		private var DarkScale:Number = 1.0;
		private var DarkArmDis:Number = 10.0;
		private var DarkFlic:Number = 0.05;
		
		private var LightScale:Number = 1.4;
		private var LightArmDis:Number = 15.0;
		private var LightFlic:Number = 0.2;
		
		private var LargeScale:Number;
		
		public function LightController(light:Light, player:Player) 
		{
			this.light = light;
			this.player = player;
			var thespriteicareabout:FlxSprite = player.getHitbox();
			preVelocity = thespriteicareabout.velocity;
			preChange = Utils.getDistance(new FlxPoint(0,0), player.maxVelocity);
		}
		
		override public function update():void {
			
			if (!player.playerHasItem(ItemType.LANTERN)) {
				LargeScale = DarkScale;
			}else {
				LargeScale = LightScale;
			}
			light.lastchord.x = light.x-(player.x +4);
			light.lastchord.y = light.y - (player.y +5);
			var angle:Number = 0;
			var center:Boolean = false;
			var radius:Number;
			if (!player.playerHasItem(ItemType.LANTERN)) {
				radius = DarkArmDis;
			}else {
				radius = LightArmDis;
			}
			
			var thespriteicareabout:FlxSprite = player.getHitbox();
			if (thespriteicareabout.velocity.x == 0 && thespriteicareabout.velocity.y == 0) {
				center = true;
			}else {
				angle = FlxU.getAngle(new FlxPoint(0, 0), new FlxPoint(Utils.sign(thespriteicareabout.velocity.x), Utils.sign(thespriteicareabout.velocity.y)));
			}
			
			/*if (Utils.sign(thespriteicareabout.velocity.x)> 0 && Utils.sign(thespriteicareabout.velocity.y) > 0) {
				angle = 45;
			}else if (Utils.sign(thespriteicareabout.velocity.x)> 0 && Utils.sign(thespriteicareabout.velocity.y) == 0) {
				angle = 0;
			}else if (Utils.sign(thespriteicareabout.velocity.x)> 0 && Utils.sign(thespriteicareabout.velocity.y) < 0) {
				angle = 315;
			}else if (Utils.sign(thespriteicareabout.velocity.x)< 0 && Utils.sign(thespriteicareabout.velocity.y) > 0) {
				angle = 135;
			}else if (Utils.sign(thespriteicareabout.velocity.x) < 0 && Utils.sign(thespriteicareabout.velocity.y) == 0) {
				angle = 180;
			}else if (Utils.sign(thespriteicareabout.velocity.x) < 0 && Utils.sign(thespriteicareabout.velocity.y) < 0) {
				angle = 225;
			}else if (Utils.sign(thespriteicareabout.velocity.x)== 0 && Utils.sign(thespriteicareabout.velocity.y) > 0) {
				angle = 90;
			}else if (Utils.sign(thespriteicareabout.velocity.x) == 0 && Utils.sign(thespriteicareabout.velocity.y) < 0) {
				angle = 270;
			}else {
				center = true;
			}*/
			
			angle += 270;
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
			var flic:Number;
			if (!player.playerHasItem(ItemType.LANTERN)) {
				flic = DarkFlic;
			}else {
				flic = LightFlic;
			}
			var scaleValue:Number = Math.max(0, Math.min(LargeScale,(1.0 - Math.abs(deltaChange * 0.05) - (Math.random() * flic)) * LargeScale) -.1);
			
			light.scale.x = scaleValue;
			light.scale.y = scaleValue;
						
			preChange = change;
			
			super.update();
		}
		
	}

}