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
				player.acceleration.x = 0;
				player.acceleration.y = 0;
				
				if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					player.acceleration.x = player.drag.x;
				}	
				if (FlxG.keys.LEFT || FlxG.keys.A)
				{
					player.acceleration.x = -player.drag.x;
				}
				if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					player.acceleration.y = player.drag.y;
				}
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					player.acceleration.y = -player.drag.y;
				}
			}
			
			if (controlScheme == 2)
			{
				//player.velocity.x = 0;
				//player.velocity.y = 0;
				
				
				if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					player.velocity.x = player.maxVelocity.x;
				}
				if (FlxG.keys.LEFT || FlxG.keys.A)
				{
					player.velocity.x = -player.maxVelocity.x;
				}
				if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					player.velocity.y = player.maxVelocity.y;
				}
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					player.velocity.y = -player.maxVelocity.y;
				}
			}
			
			if (controlScheme == 3)
			{
				
			}
			
			
			
			if(player.velocity.x != 0 || player.velocity.y != 0){
				var velocityp:FlxPoint = new FlxPoint(player.velocity.x, player.velocity.y);
				var origin:FlxPoint = new FlxPoint(0, 0);
				player.angle = FlxU.getAngle(origin, velocityp);
			}
			
			
			/*var p1:FlxPoint = new FlxPoint(player.x, player.y);
			var p2:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			player.angle = FlxU.getAngle(p1, p2);*/
			
			stepDis += Utils.getDistance(prePosition, player.getMidpoint());
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
			
			
			player.deltaPosition.x = player.x - player.lastPosition.x;
			player.deltaPosition.y = player.y - player.lastPosition.y;
			player.lastPosition.x = player.x;
			player.lastPosition.y = player.y;
			super.update();
		}
	}

}
