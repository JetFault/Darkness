package  
{
	import de.polygonal.ds.Heapable;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import Map;
	/**
	 * ...
	 * @author Darkness Team
	 */
	class HeapItem implements de.polygonal.ds.Heapable {
		public var value:uint;
		public var position:uint; //internal use, never change!
		private var depth:uint;
		private var tilelocation:FlxPoint;
		private var distancetraveled:uint;
		
		public function HeapItem(map:Map, playerpoint:FlxPoint, tilelocation:FlxPoint, depth:uint, distancetraveled:uint) {
			this.depth = depth;
			this.tilelocation = tilelocation;
			this.distancetraveled = distancetraveled;
			var path:FlxPath = map.findPath(Utils.tilePtToMidpoint(map, tilelocation), playerpoint);
			if(path){
				this.value = Utils.getPathDistance(path);
				path.destroy();
			}else {
				this.value = 0;
			}
		}
	
	
		public function compare(other:Object):int {
			var o:HeapItem = other as HeapItem;
			return (o.value) - (this.value);
			//return (this.value + this.distancetraveled) - (o.value + o.distancetraveled);
		}
		
		
		public function equals(other:HeapItem):Boolean {
			return this.tilelocation.x == other.tilelocation.x && this.tilelocation.y == other.tilelocation.y;
		}
		
		public function getDepth():uint {
			return this.depth;
		}
		
		public function getTileLocation():FlxPoint {
			return this.tilelocation;
		}
	}

}