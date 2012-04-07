package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		//Sprite sheet
		[Embed(source = "../bin/data/Player3.png")] protected var ImgPlayer:Class;
		
		private var _runspeed:Number;
		private var controller:PlayerController;
		private var playerAlive:Boolean;
		public var lastPosition:FlxPoint;
		public var deltaPosition:FlxPoint;
		public var inventory:Array;
		
		public function Player(x:Number, y:Number)
		{
			super(x, y, null);
			this.x = x;
			this.y = y;
			this.playerAlive = true;
			loadPlayer();
			maxVelocity.x = 52;
			maxVelocity.y = 52;
			_runspeed = 70;
			drag.x = _runspeed * 2.3;
			drag.y = _runspeed * 2.3;
			this.controller = new PlayerController(this, Constants.controlScheme);
			elasticity = .7;
			lastPosition = new FlxPoint(this.x, this.y);
			deltaPosition = new FlxPoint(0, 0);
			inventory = new Array();
		}
		
		private function loadPlayer():void
		{
			loadGraphic(ImgPlayer, true, true, 15, 15);
			//super.makeGraphic(10, 10, 0xff007fff);
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
		
		public function playerHasItem(itemType:ItemType):Boolean {
			for (var i:int = 0; i < inventory.length; i++)
			{
				if (inventory[i].getItemType() == itemType) 
				{
					return true;
				}
			}
			return false;
		}
	}

}
