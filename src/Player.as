package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		//Sprite sheet
		[Embed(source = "../bin/data/Player.png")] protected var ImgPlayer:Class;
		
		private var _runspeed:Number;
		private var controller:PlayerController;
		private var playerAlive:Boolean;
		
		public function Player(x:Number, y:Number)
		{
			super(x, y, null);
			this.x = x;
			this.y = y;
			this.playerAlive = true;
			loadPlayer();
			maxVelocity.x = 40;
			maxVelocity.y = 40;
			_runspeed = 80;
			drag.x = _runspeed * 4;
			drag.y = _runspeed * 4;
			this.controller = new PlayerController(this);
		}
		
		private function loadPlayer():void
		{
			//loadGraphic(ImgPlayer, true, true, 12, 9);
			super.makeGraphic(12, 12, 0xff007fff);
		}
		
		override public function update():void
		{
			//velocity.x = 0;
			//velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			
			if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				acceleration.x += drag.x;
			}
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{
				acceleration.x += -drag.x;
			}
			if (FlxG.keys.DOWN || FlxG.keys.S)
			{
				acceleration.y += drag.x;
			}
			if (FlxG.keys.UP || FlxG.keys. W)
			{
				acceleration.y += -drag.x
			}
			controller.update();
		}
		
		public function isAlive():Boolean {
			return this.playerAlive;
		}
		
		override public function kill():void {
			this.playerAlive = false;
			super.kill();
		}
		
		public function getController(): BaseController {
			return this.controller;
		}
		
	}

}