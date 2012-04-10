package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxSprite;
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		//Sprite sheet
		[Embed(source = "../bin/data/PlayerAnimation.png")] protected var ImgPlayer:Class;
		[Embed(source = "../bin/data/PlayerLightAnimation.png")] protected var ImgPlayerLight:Class;
		
		private var _runspeed:Number;
		private var controller:PlayerController;
		private var playerAlive:Boolean;
		public var lastPosition:FlxPoint;
		public var deltaPosition:FlxPoint;
		public var inventory:Array;
		public var hitbox:FlxSprite;
		
		public function Player(x:Number, y:Number)
		{
			super(x, y, null);
			this.x = x;
			this.y = y;
			this.hitbox = new FlxSprite(this.getMidpoint().x, this.getMidpoint().y);
			hitbox.makeGraphic(8, 8, 0x00ff0000);
			hitbox.x = this.getMidpoint().x - hitbox.width / 2;
			hitbox.y = this.getMidpoint().y - hitbox.height / 2;
			this.playerAlive = true;
			loadPlayer();
			maxVelocity.x = 52;
			maxVelocity.y = 52;
			hitbox.maxVelocity = maxVelocity;
			_runspeed = 70;
			drag.x = _runspeed * 2.3;
			drag.y = _runspeed * 2.3;
			hitbox.drag = this.drag;
			this.controller = new PlayerController(this, Constants.controlScheme);
			elasticity = .7;
			hitbox.elasticity = elasticity;
			lastPosition = new FlxPoint(this.x, this.y);
			deltaPosition = new FlxPoint(0, 0);
			inventory = Persistence.inventory;

			addAnimation("walk", [0, 1, 0, 2], 5);
			addAnimation("stop", [0], 1);
		}
		
		private function loadPlayer():void
		{
			loadGraphic(ImgPlayer, true, true, 15, 15);
			//super.makeGraphic(10, 10, 0xff007fff);
		}
		public function loadLantern():void {
			loadGraphic(ImgPlayerLight, true, true, 15, 15);
			//addAnimation("walk", [0, 1, 0, 2], 5);
		}
		
		public function isAlive():Boolean {
			return this.playerAlive;
		}
		
		override public function kill():void {
			this.playerAlive = false;
			this.getHitbox().kill();
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
		
		public function getHitbox():FlxSprite {
			return this.hitbox;
		}
		
	}

}
