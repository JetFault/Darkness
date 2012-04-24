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
		
		private var flashdebug:Boolean = false;
		public var lightningcolor:uint = 0x00d5d7ff; //0x00ffffff 0x00b5b7ff
		private var firstflashed:Boolean = false;
		private var firstflashedtimer:Number = 0;
		private var howlongsincelast:Number = 0;
		private var cutoffscale:Number = 1;
		private var flashedwhenobtainedumbrellaupdate:Boolean = false;
		private var flashedwhenobtainedumbrellashouldflash:Boolean = false;
		
		
		public function Lightning(darkness:FlxSprite,player:Player, enemiesreal:FlxGroup,enemieshallucination:FlxGroup) 
		{
			//load sounds
			rumbleflxsound = FlxG.loadSound(RumbleSound);
			crashflxsound = FlxG.loadSound(CrashSound);
			
			this.darkness = darkness;
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
			//Timer for first flash
			firstflashedtimer += FlxG.elapsed;
			//Umbrella check
			if (player.playerHasItem(ItemType.UMBRELLA)) {
				lightningcolor = Constants.WITHOUTUMBRELLACOLOR;
				if (!flashedwhenobtainedumbrellaupdate) {
					flashedwhenobtainedumbrellaupdate = true;
					flashing = false;
				}
			}else {
				lightningcolor = Constants.WITHOUTUMBRELLACOLOR;
			}
			
			//Debug controls
			if (FlxG.keys.justPressed("L") && Constants.debug) {
				if (Constants.darknesscolor == Constants.CLEARDARKNESSCOLOR) {
					Constants.darknesscolor = Constants.DEFAULTDARKNESSCOLOR;
				}else if (Constants.darknesscolor == Constants.DEFAULTDARKNESSCOLOR) {
					Constants.darknesscolor = Constants.CLEARDARKNESSCOLOR;
				}
			}
			if (FlxG.keys.justPressed("K") && Constants.debug) {
				this.flashdebug = true;
			}
			
			
			//More timers
			howoften += FlxG.elapsed;
			looptimer += FlxG.elapsed;
			soundtimer += FlxG.elapsed;
			soundplayedtimer += FlxG.elapsed;
			//Timer for flash
			if (flashing) {
				flashtimer += FlxG.elapsed;
			}	
			
			if(flashtimer >=Constants.flashduration && soundplayedtimer >=(soundcutofftime + Math.max(Constants.rumbletime, Constants.crashtime))*cutoffscale){
				flashing = false;
				bufferfull = false;
				//trace((soundcutofftime + Math.max(Constants.rumbletime, Constants.crashtime))*cutoffscale);
			}
			
			if(Constants.periodic){
				if (looptimer >=Constants.looptime) {
					startFlashing();
				}
			}else {
				if (!flashing) {
					howlongsincelast += FlxG.elapsed;
					if (shouldflash("enemyeuclidean")) {
						startFlashing();
						howlongsincelast = 0;
					}
				}
			}
			
			
			
			if (!soundplayed) {
				if (distance < Constants.soundthreshold && soundtimer >= Constants.crashtime) {
					crashflxsound.play();
					soundcutofftime = Constants.crashduration;
					soundplayed = true;
					crashflxsound.autoDestroy = true;
					crashflxsound = FlxG.loadSound(CrashSound);
				}else if (distance >= Constants.soundthreshold && soundtimer >= Constants.rumbletime) {
					rumbleflxsound.play();
					soundcutofftime = Constants.crashduration;
					soundplayed = true;
					rumbleflxsound.autoDestroy = true;
					rumbleflxsound = FlxG.loadSound(RumbleSound);
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
			this.camera.fill(lightningcolor + (cameratransparency<<24));
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
			
			var scale:Number = 1.2;
			if (player.playerHasItem(ItemType.UMBRELLA)) {
				scale = 9;
				this.cutoffscale = 7 / 9;
			}else {
				this.cutoffscale = 9.5 / 9;
			}
			
			
			if (flashdebug) {
				flashdebug = false;
				return true;
			}
			//First flash
			if (!firstflashed) {
				if (firstflashedtimer >= 0.5) {
					firstflashed = true;
					return true;
				}else {
					return false;
				}
			}
			
			//Introlevel.  Flash once then don't flash again
			if (FlxG.level == 0) {
				return false;
			}
			
			if (FlxG.level == Constants.purgatoryLevel) {
				return false;
			}
			
			if (player.playerHasItem(ItemType.UMBRELLA)) {
				if (!flashedwhenobtainedumbrellashouldflash) {
					flashedwhenobtainedumbrellashouldflash = true;
					return true;
				}
				if (howlongsincelast >= 1) {
					return true;
				}
			}else {
				if (howlongsincelast >= 2) {
					return true;
				}
			}
			if (criteria == "enemyeuclidean") {
				var c:Number = Math.random();
				var threshold:Number = 0;
				for (var i:uint = 0; i < enemiesreal.members.length; i++) {
					var e:Enemy = enemiesreal.members[i] as Enemy;
					if (e && e.alive) {
						threshold = Math.max(threshold, Utils.inverseeuclidean(player.getMidpoint(), e.getMidpoint(), .5) * scale);
					}
				}
				for (i = 0; i < enemieshallucination.members.length; i++) {
					e = enemieshallucination.members[i] as Enemy;
					if (e && e.alive){
						threshold = Math.max(threshold, Utils.inverseeuclidean(player.getMidpoint(), e.getMidpoint(), .5) * scale);
					}
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