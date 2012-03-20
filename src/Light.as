package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	
	public class Light extends FlxSprite
	{
		//[Embed(source="/../bin/data/glow-light.png")]private var LightImageClass:Class;
		[Embed(source="/../bin/data/NearLight.png")] private var LightImageClass:Class;
		private var darkness:FlxSprite;
		public var controller:LightController;
		
		public function Light(x:Number, y:Number, darkness:FlxSprite, player:Player):void
		{
			super(x, y, LightImageClass);
			this.darkness = darkness;
			//this.blend = "screen";
			this.controller = new LightController(this, player);
		}
		
		override public function draw():void
		{
			var screenXY:FlxPoint = getScreenXY();
			darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
		}
		
		public function getController():BaseController {
			return this.controller;
		}
		
	}
}