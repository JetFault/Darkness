package  
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class Lightning extends FlxSprite
	{
		[Embed(source = "../bin/data/Crackle_W_Low_Rumble_8_seconds.mp3")] protected var RumbleSound:Class;
		[Embed(source = "../bin/data/Bright_Airy_Zap_W_Midrange_Short_Decay_6_seconds.mp3")] protected var CrashSound:Class;
				
		//Darkness
		private var darkness:FlxSprite;
		//For periodic loop lightning
		private var looptimer:Number = 0;
		
		
		//for drawing the darkness
		private var flashtimer:Number = 0;
		private var flashing:Boolean = false;
		
		private var soundplayed:Boolean = true;
		private var played:Boolean = false;
		
		private var rumbleflxsound:FlxSound;
		private var crashflxsound:FlxSound;
		private var player:Player;
		private var enemy:Enemy;
		
		private var soundtimer:Number = 0;
		private var distance:Number = 0;
		private var camera:FlxCamera;
		private var flashbuffer:Array;
		private var bufferfull = false;
		private var buffersize:uint = 33;
		
		
		public function Lightning(darkness:FlxSprite,player:Player, enemy:Enemy) 
		{
			this.darkness = darkness;
			rumbleflxsound = new FlxSound();
			rumbleflxsound.loadEmbedded(RumbleSound);
			crashflxsound = new FlxSound();
			crashflxsound.loadEmbedded(CrashSound);
			this.player = player;
			this.enemy = enemy;
			this.camera = FlxG.cameras[0] as FlxCamera;
		}
		
		override public function draw():void {
			if (darkness != null) {
				if (flashing) {
					flashtimer += FlxG.elapsed;
					soundtimer += FlxG.elapsed;
					if (flashtimer > Constants.flashduration) {
						flashing = false;
						flashtimer = 0;
						bufferfull = false;
						darkness.fill(0xff000000);
					}else {
						this.drawFlash();
					}
				}else {
					darkness.fill(0xff000000);
				}				
				//ROFL uncomment 2 lines below and comment surrounding lines in this function for neat effect
				//darkness.alpha = 1;
				//darkness.draw();
			}
		}
		
		override public function update():void {
			looptimer += FlxG.elapsed;
			if(Constants.periodic){
				if (looptimer >=Constants.looptime) {
					//FlxG.flash(0xffffffff, Constants.flashduration);
					flashtimer = 0;
					soundtimer = 0;
					soundplayed = false;
					flashing = true;
					looptimer = 0;
					bufferfull = false;
					distance = Utils.getDistance(player.getMidpoint(), enemy.getMidpoint());
				}
			}
			
			soundtimer += FlxG.elapsed;
			if (flashing) {
				flashtimer += FlxG.elapsed;
			}	
			
			if (!soundplayed) {
				if (distance < Constants.soundthreshold && soundtimer >= Constants.crashtime) {
					crashflxsound.play();
					soundplayed = true;
				}else if (distance >= Constants.soundthreshold && soundtimer >= Constants.rumbletime) {
					rumbleflxsound.play();
					soundplayed = true;
				}
			}
		}
		
		/**
		 * Assumes flashtimer < flashduration
		 */
		//private var framecount:Number = 0;
		private function drawFlash():void {
			//framecount++;
			var cameratransparency:Number = 0;
			if (Constants.functiontype == "batch") {
				if (!bufferfull) {
					flashbuffer = Utils.brownian(buffersize);
					bufferfull = true;
				}
				cameratransparency = flashbuffer[uint(Math.floor(flashtimer / Constants.flashduration * flashbuffer.length))];
			}else if (Constants.functiontype == "sequential") {
				cameratransparency = Constants.flashfunctionsequential(flashtimer / Constants.flashduration);
			}
			var darknesstransparency:Number = uint(0xff - Constants.cameralightningdiff*cameratransparency); //Constants.flashfunction(flashtimer / Constants.flashduration)
			//darkness.fill(0xff000000);
			darkness.fill(darknesstransparency << 24); 
			this.camera.fill(Constants.lightningcolor + (cameratransparency<<24));
		}
	}

}