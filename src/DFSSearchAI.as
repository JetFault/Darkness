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
		public function DFSSearchAI(self:Enemy,player:Player, map:Map) 
		{
			depth = 20;
			super(self, player, map);
			this.xpos = 30;
			this.ypos = 2;
		}
		
		override protected function getAutoPath():Array {
			return Utils.createDFSPath(map, depth, self);
		}
	}
}