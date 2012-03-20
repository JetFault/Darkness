package  
{
	/**
	 * ...
	 * @author DarknessTeam
	 */
	import org.flixel.*;
	
	public class FlashLight extends FlxSprite
	{
		[Embed(source="/../bin/data/FlashLight.png")] private var FlashLightImageClass:Class;
		private var darkness:FlxSprite;
		public var controller:FlashLightController;
		public var drawLight:Boolean;
		
		public function FlashLight(x:Number, y:Number, darkness:FlxSprite, player:Player):void
		{
			super(x, y, FlashLightImageClass);
			this.darkness = darkness;
			//this.blend = "screen";
			this.controller = new FlashLightController(this, player);
			this.origin.x = 30;
			this.origin.y = 118;
			drawLight = false;
		}
		
		override public function draw():void
		{
			if(this.drawLight){
				var screenXY:FlxPoint = getScreenXY();
				if(darkness != null) {
					darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
				}
			}
		}
		
		public function getController():BaseController {
			return this.controller;
		}
		
		public function toggledraw():void {
			this.drawLight = !this.drawLight;
		}
		
		public function onDraw():void {
			this.drawLight = true;
		}
		public function offDraw():void {
			this.drawLight = false;
		}
		
	}
}