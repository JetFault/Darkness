package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		//Sprite sheet
		//[Embed(source = "../bin/data/Player.png")] protected var ImgPlayer:Class;
		
		private var _runspeed:Number;
		//private var controller:PlayerController;
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
			//this.controller = new PlayerController(this);
		}
		
		private function loadPlayer():void
		{
			//loadGraphic(ImgPlayer, true, true, 12, 9);
			super.makeGraphic(10, 10, 0xff007fff);
		}
		
		public function isAlive():Boolean {
			return this.playerAlive;
		}
		
		override public function kill():void {
			this.playerAlive = false;
			super.kill();
		}
		
		//public function getController(): BaseController {
		//	return this.controller;
		//}
		
		
		override public function update():void {
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			
			if (FlxG.keys.RIGHT || FlxG.keys.D)
			{
				this.acceleration.x += this.drag.x;
			}
			if (FlxG.keys.LEFT || FlxG.keys.A)
			{
				this.acceleration.x += -this.drag.x;
			}
			if (FlxG.keys.DOWN || FlxG.keys.S)
			{
				this.acceleration.y += this.drag.x;
			}
			if (FlxG.keys.UP || FlxG.keys.W)
			{
				this.acceleration.y += -this.drag.x;
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
