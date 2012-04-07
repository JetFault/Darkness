package  
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxGroup;
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
		private var flashcount:Number = 0;  //How many times has this flashed
		
		
		//for drawing the darkness
		private var flashtimer:Number = 0;
		private var flashing:Boolean = false;
		
		private var soundplayed:Boolean = true;
		private var soundplayedtimer:Number = 0;
		
		private var rumbleflxsound:FlxSound;
		private var crashflxsound:FlxSound;
		private var player:Player;
		private var enemiesreal:FlxGroup;
		private var enemieshallucination:FlxGroup;
		
		private var soundtimer:Number = 0;
		private var distance:Number = 0;
		private var camera:FlxCamera;
		private var flashbuffer:Array;
		private var bufferfull:Boolean = false;
		private var buffersize:uint = 33;
		
		private var howoften:uint = 0;
		private var soundcutofftime:Number = 8; //Minimum amount of time until next flash
		
		
		public function Lightning(darkness:FlxSprite,player:Player, enemiesreal:FlxGroup,enemieshallucination:FlxGroup) 
		{
			this.darkness = darkness;
			rumbleflxsound = FlxG.loadSound(RumbleSound);
			crashflxsound = FlxG.loadSound(CrashSound);
			this.player = player;
			this.enemiesreal = enemiesreal;
			this.enemieshallucination = enemieshallucination;
			this.camera = FlxG.cameras[0] as FlxCamera;
		}
		
		override public function draw():void {
			if (darkness != null) {
				if (flashing) {
					if (flashtimer > Constants.flashduration) {
						darkness.fill((0xff<<24) + Constants.darknesscolor);
					}else {
						this.drawFlash();
					}
				}else {
					darkness.fill((0xff<<24) + Constants.darknesscolor);
				}				
			}
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("L")) {
				if (Constants.darknesscolor == Constants.CLEARDARKNESSCOLOR) {
					Constants.darknesscolor = Constants.DEFAULTDARKNESSCOLOR;
				}else if (Constants.darknesscolor == Constants.DEFAULTDARKNESSCOLOR) {
					Constants.darknesscolor = Constants.CLEARDARKNESSCOLOR;
				}
			}
			howoften += FlxG.elapsed;
			looptimer += FlxG.elapsed;
			soundtimer += FlxG.elapsed;
			soundplayedtimer += FlxG.elapsed;
			if (flashing) {
				flashtimer += FlxG.elapsed;
			}	
			
			if(flashtimer >=Constants.flashduration && soundplayedtimer >=soundcutofftime + Math.max(Constants.rumbletime, Constants.crashtime)){
				flashing = false;
				bufferfull = false;
			}
			
			if(Constants.periodic){
				if (looptimer >=Constants.looptime) {
					startFlashing();
				}
			}else {
				if (!flashing) {
					if (shouldflash("enemyeuclidean")) {
						startFlashing();
					}
				}
			}
			
			
			
			if (!soundplayed) {
				if (distance < Constants.soundthreshold && soundtimer >= Constants.crashtime) {
					crashflxsound.play();
					soundcutofftime = Constants.crashduration;
					soundplayed = true;
				}else if (distance >= Constants.soundthreshold && soundtimer >= Constants.rumbletime) {
					rumbleflxsound.play();
					soundcutofftime = Constants.rumbleduration;
					soundplayed = true;
				}
			}
		}
		
		/**
		 * Assumes flashtimer < flashduration
		 */
		private function drawFlash():void {
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
			darkness.fill((darknesstransparency << 24) + Constants.darknesscolor); 
			this.camera.fill(Constants.lightningcolor + (cameratransparency<<24));
		}
		
		private function startFlashing():void {
			flashtimer = 0;
			soundtimer = 0;
			soundplayed = false;
			flashing = true;
			looptimer = 0;
			bufferfull = false;
			soundplayedtimer = 0;
			distance = Utils.getMinDistance(player.getMidpoint(), enemiesreal);
			distance = Math.min(distance, Utils.getMinDistance(player.getMidpoint(), enemieshallucination));
			flashcount++;
		}
		
		private function shouldflash(criteria:String):Boolean {
			
			var scale:Number = 1.0;
			if (player.playerHasItem(ItemType.UMBRELLA)) {
				scale = 2.0;
			}
			if (criteria == "enemyeuclidean") {
				var c:Number = Math.random();
				var threshold:Number = 0;
				for (var i:uint = 0; i < enemiesreal.members.length; i++) {
					var e:Enemy = enemiesreal.members[i] as Enemy;
					threshold = Math.max(threshold, Utils.inverseeuclidean(player.getMidpoint(), e.getMidpoint(), .5) * scale);
				}
				for (i = 0; i < enemieshallucination.members.length; i++) {
					e = enemieshallucination.members[i] as Enemy;
					threshold = Math.max(threshold, Utils.inverseeuclidean(player.getMidpoint(), e.getMidpoint(), .5) * scale);
				}

				return c <= threshold;
			}else if (criteria == "flashcount") {
				var s:Number = Utils.sampleradial(Math.pow(50, flashcount));
				return s >= .9;
			}
			return false;
		}
	}

}