package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import flash.sampler.NewObjectSample;
	import org.flixel.*;
	
	public class Light extends FlxSprite
	{
		[Embed(source = "/../bin/data/glow-lightBlue2.png")]private var LightImageClass:Class;
		[Embed(source = "/../bin/data/glow-lightYellow.png")]private var LanternImageClass:Class;

		private var darkness:FlxSprite;
		public var controller:LightController;
		public var level:Map;
		public var scaletimer:Number = 0;
		public var lastchord:FlxPoint;
		public var radius:Number = 40;
		
		public function Light(x:Number, y:Number, darkness:FlxSprite, player:Player, level:Map):void
		{
			super(x, y, LightImageClass);
			this.darkness = darkness;
			//this.blend = "screen";
			this.controller = new LightController(this, player);
			this.level = level;
			lastchord = new FlxPoint(0, 0);
		}
		
		override public function draw():void
		{
			var screenXY:FlxPoint = getScreenXY();
			if(darkness != null) {
				darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
			}
			
		}
		
		public function getController():BaseController {
			return this.controller;
		}
		
		public function loadLantern():void {
			this.loadGraphic(LanternImageClass);
		}
		
	}
}