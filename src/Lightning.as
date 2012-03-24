package  
{
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
		
		private var darkness:FlxSprite;
		private var looptime:Number = 15;
		private var looptimer:Number = 0;
		private var flashduration:Number = .25;
		private var flashtimer:Number = 0;
		private var flashing:Boolean = false;
		private var crashtime:Number = .01;
		private var played:Boolean = false;
		private var rumbletime:Number = 0.2;
		private var rumbleflxsound:FlxSound;
		private var crashflxsound:FlxSound;
		private var player:Player;
		private var enemy:Enemy;
		private var soundthreshold:Number = 100;
		
		
		public function Lightning(darkness:FlxSprite,player:Player, enemy:Enemy) 
		{
			this.darkness = darkness;
			rumbleflxsound = new FlxSound();
			rumbleflxsound.loadEmbedded(RumbleSound);
			crashflxsound = new FlxSound();
			crashflxsound.loadEmbedded(CrashSound);
			this.player = player;
			this.enemy = enemy;
		}
		
		override public function draw():void {
			if (darkness != null) {
				if (flashing) {
					flashtimer += FlxG.elapsed;
					if (flashtimer > flashduration) {
						flashing = false;
						flashtimer = 0;
						darkness.fill(0xff000000);
					}else {
						var transparency:Number = Math.floor((flashtimer) * 255/flashduration);
						darkness.fill(transparency << 24);
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
			if (looptimer >=looptime) {
				FlxG.flash(0xffffffff, flashduration);
				flashtimer = 0;
				flashing = true;
				looptimer = 0;
			}
			
			if (flashing) {
				flashtimer += FlxG.elapsed;
				var distance:Number = getEnemyDistance(player.getMidpoint(), enemy.getMidpoint());
				if (distance < soundthreshold && flashtimer >= crashtime) {
					crashflxsound.play();
				}else if (distance >= soundthreshold && flashtimer >= rumbletime) {
					rumbleflxsound.play();
				}
			}	
		}
		
		private function getEnemyDistance(playerPos:FlxPoint, enemyPos:FlxPoint):Number
		{
			var xDist:Number = playerPos.x - enemyPos.x;
			var yDist:Number = playerPos.y - enemyPos.y;
			var distance:Number = Math.sqrt(xDist * xDist + yDist * yDist);
			return distance;
		}
	}

}