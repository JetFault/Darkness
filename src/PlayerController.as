package  
{
	/**
	 * ...
	 * @author Darkness Team
	 */
	import org.flixel.*;
	public class PlayerController extends BaseController
	{
		
		[Embed(source = "../bin/data/MetalFootStep1.mp3")] protected var PlayerStepSound1:Class;
		[Embed(source = "../bin/data/MetalFootStep2.mp3")] protected var PlayerStepSound2:Class;
		[Embed(source = "../bin/data/MetalFootStep3.mp3")] protected var PlayerStepSound3:Class;
		
		private var playerStep1:FlxSound;
		private var playerStep2:FlxSound;
		private var playerStep3:FlxSound;
		
		private var preStep:Boolean = false;
		
		private var stepDis:Number = 0;
		private var stepLength:Number = 25;
		private var prePosition:FlxPoint;
		
		private var player:Player;
		private var controlScheme:int;
		private var currentAngle:Number = 0;
		
		public function PlayerController(player:Player, controlScheme:int) 
		{
			playerStep1 = FlxG.loadSound(PlayerStepSound1, 0.1);
			playerStep2 = FlxG.loadSound(PlayerStepSound2, 0.1);
			playerStep3 = FlxG.loadSound(PlayerStepSound3, .07);
			this.player = player;
			this.controlScheme = controlScheme;
			prePosition = player.getMidpoint();
		}
		
		override public function update():void 
		{
			//var whattomove:FlxSprite = player;
			var whattomove:FlxSprite = player.getHitbox();
			/*
			if (player.velocity.y != 0 || player.velocity.x != 0)
			{
				var velocityp:FlxPoint = new FlxPoint(player.velocity.x, player.velocity.y);
				var origin:FlxPoint = new FlxPoint(0, 0);
				currentAngle = FlxU.getAngle(origin, velocityp);
				currentAngle = Math.abs(currentAngle - 90);
			}
			*/
			
			if (controlScheme == 1)
			{
				whattomove.acceleration.x = 0;
				whattomove.acceleration.y = 0;
				
				if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					whattomove.acceleration.x = player.drag.x;
				}	
				if (FlxG.keys.LEFT || FlxG.keys.A)
				{
					whattomove.acceleration.x = -player.drag.x;
				}
				if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					whattomove.acceleration.y = player.drag.y;
				}
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					whattomove.acceleration.y = -player.drag.y;
				}
			}
			
			if (controlScheme == 2)
			{
				//player.velocity.x = 0;
				//player.velocity.y = 0;
				
				
				if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					whattomove.velocity.x = player.maxVelocity.x;
				}
				if (FlxG.keys.LEFT || FlxG.keys.A)
				{
					whattomove.velocity.x = -player.maxVelocity.x;
				}
				if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					whattomove.velocity.y = player.maxVelocity.y;
				}
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					whattomove.velocity.y = -player.maxVelocity.y;
				}
				var length:Number = Utils.getDistance(new FlxPoint(0, 0), player.velocity);
				if (length != 0) {
					player.play("walk");
				} else {
					player.play("stop");
				}
			}
			
			if (controlScheme == 3)
			{
				
			}
			
			
			
			if(whattomove.velocity.x != 0 || whattomove.velocity.y != 0){
				var velocityp:FlxPoint = new FlxPoint(whattomove.velocity.x, whattomove.velocity.y);
				var origin:FlxPoint = new FlxPoint(0, 0);
				whattomove.angle = FlxU.getAngle(origin, velocityp);
				player.angle = FlxU.getAngle(origin, velocityp);
			}
			
			
			/*var p1:FlxPoint = new FlxPoint(player.x, player.y);
			var p2:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			player.angle = FlxU.getAngle(p1, p2);*/
			
			stepDis += Utils.getDistance(prePosition, whattomove.getMidpoint());
			if (stepDis >= stepLength) {
				/*var rand:Number = Math.random();
				if (rand < (1/3)) 			{	playerStep1.play(true); }
				else if (rand < (2/3)) 		{	playerStep2.play(true); }
				else 						{	playerStep3.play(true); }
				*/
				if (preStep) {
					playerStep2.play(true);
					preStep = false;
				} else {
					playerStep3.play(true);
					preStep = true;
				}
				stepDis = 0;
			}
			prePosition = player.getMidpoint();
			
			
			player.deltaPosition.x = whattomove.x - player.lastPosition.x;
			player.deltaPosition.y = whattomove.y - player.lastPosition.y;
			player.lastPosition.x = whattomove.x;
			player.lastPosition.y = whattomove.y;
			player.x = player.getHitbox().getMidpoint().x - player.width/2;
			player.y = player.getHitbox().getMidpoint().y - player.height/2;
			super.update();
		}
	}

}
