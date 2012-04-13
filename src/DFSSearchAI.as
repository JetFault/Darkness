package  
{
	import flash.geom.Point;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxPath;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Darkness Team
	 */
	public class DFSSearchAI extends EnemyAI 
	{		
		public function DFSSearchAI(self:Enemy, player:Player, map:Map, onpathcompletion:String) 
		{
			
			super(self, player, map, onpathcompletion);
			this.xpos = 30;
			this.ypos = 2;
			this.depth = 5;
		}
		
		override protected function getAutoPath(currentpoint:FlxPoint):Array {
			return Utils.createDFSPath(map, depth, currentpoint);
		}
	}
}