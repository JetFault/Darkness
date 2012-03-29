package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	
	public class Light extends FlxSprite
	{
		[Embed(source="/../bin/data/glow-light.png")]private var LightImageClass:Class;

		private var darkness:FlxSprite;
		public var controller:LightController;
		public var level:Map;
		public var scaletimer = 0;
		
		public function Light(x:Number, y:Number, darkness:FlxSprite, player:Player, level:Map):void
		{
			super(x, y, LightImageClass);
			this.darkness = darkness;
			//this.blend = "screen";
			this.controller = new LightController(this, player);
			this.level = level;
		}
		
		override public function draw():void
		{
			var screenXY:FlxPoint = getScreenXY();
			if(darkness != null) {
				darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
			}
			
		}
		
		public function getController():BaseController {
			return this.controller;
		}
		
	}
}


// RAY TRACING CODE FOR DRAW()
/*this.fill(0xffffffff);
			
			if (Constants.raytracelight) {
				var midpoint:FlxPoint = new FlxPoint(this.x + this.width/2, this.y + this.height/2);
				var radius:Number = 20;
				var where:FlxPoint = new FlxPoint();
				
				for (var i:Number = 0; i < 360; i++) {
					var end:FlxPoint = new FlxPoint(midpoint.x + radius * Math.cos(i / 180 * Math.PI), midpoint.y + radius * Math.sin(i / 180 * Math.PI));
					this.drawLine(end.x-this.x, end.y-this.y, end.x -this.x + 1, end.y -this.y + 1,0xffff0000);
					//this.drawLine(midpoint.x - this.x, midpoint.y - this.y, end.x - this.x, end.y - this.y, 0xff00ffff);
					
					if (!level.ray(new FlxPoint(midpoint.x-level.x, midpoint.y-level.y), new FlxPoint(end.x-level.x,end.y-level.y), where,5)) {
						if (i == 1) {
							trace(where.x);
							trace(where.y);
							trace(midpoint.x);
							trace(midpoint.y);
							trace(end.x);
							trace(end.y);
						}
						this.drawLine(where.x-this.x,where.y-this.y,where.x-this.x+1,where.y-this.y+1,0xff00ffff);
						//this.drawLine(end.x-this.x,end.y-this.y,end.x-this.x+5,end.y-this.y+5, 0xffffffff);
						//this.drawLine(where.x-this.x, where.y-this.y,where.x-this.x+1, where.y-this.y+1, 0xffff0000);
					}
					var tile:FlxPoint = new FlxPoint();
					//if (level.rayCast(midpoint, end, where, tile)) {
						this.drawLine(where.x-this.x,where.y-this.y,where.x-this.x+1,where.y-this.y+1,0xff00ffff);
						//this.drawLine(end.x-this.x,end.y-this.y,end.x-this.x+5,end.y-this.y+5, 0xffffffff);
						//this.drawLine(where.x-this.x, where.y-this.y,where.x-this.x+1, where.y-this.y+1, 0xffff0000);
					//}

				}
				
			}//else {
			this.drawLine(0, 0, this.width/2, this.height/2,0xffffff00);*/

//RAY TRACING CODE FROM GREG

/**
		 * RAY CASTING CODE HERE. Thanks, Adam...(sarcastic)
		 * Thanks, Greg :-) (genuine)
		 */
		
		 /**
021
   * Casts a ray from the start point until it hits either a filled tile, or the edge of the tilemap
022
   *
023
   * If the starting point is outside the bounding box of the tilemap,
024
   * it will not cast the ray, and place the end point at the start point.
025
   *
026
   * Warning: If your ray is completely horizontal or vertical, make sure your x or y values are exactly zero.
027
   * Otherwise you may suffer the wrath of floating point rounding error!
028
   *
029
   * Algorithm based on
030
   * http://www.metanetsoftware.com/technique/tutorialB.html
031
   * http://www.cse.yorku.ca/~amana/research/grid.pdf
032
   * http://www.flipcode.com/archives/Raytracing_Topics_Techniques-Part_4_Spatial_Subdivisions.shtml
033
   *
034
   * @param start    the starting point of the ray
035
   * @param direction   the direction to shoot the ray. Does not need to be normalized
036
   * @param result   where the resulting point is stored, in (x,y) coordinates
037
   * @param resultInTiles  a point containing the tile that was hit, in tile coordinates (optional)
038
   * @param maxTilesToCheck The maximum number of tiles you want the ray to pass. -1 means go across the entire tilemap. Only change this if you know what you're doing!
039
   * @return      true if hit a filled tile, false if it hit the end of the tilemap
040
   *
041
   */
/*
  public function rayCast(start:FlxPoint, direction:FlxPoint, result:FlxPoint=null, resultInTiles:FlxPoint=null, maxTilesToCheck:int=-1):Boolean
  {
   var cx:Number, cy:Number,    // current x, y, in tiles
    cbx:Number, cby:Number,    // starting tile cell bounds, in pixels
    tMaxX:Number, tMaxY:Number,   // maximum time the ray has traveled so far (not distance!)
    tDeltaX:Number, tDeltaY:Number,  // the time that the ray needs to travel to cross a single tile (not distance!)
    stepX:Number, stepY:Number,   // step direction, either 1 or -1
    outX:Number, outY:Number,   // bounds of the tileMap where the ray would exit
    hitTile:Boolean = false,   
    tResult:Number = 0;

   if(start == null)
    return false;

   if(result == null)
    result = new FlxPoint();

   if(direction == null || (direction.x == 0 && direction.y == 0) )
   {
    // no direction, no ray
    result.x = start.x;
    result.y = start.y;
    return false;
   }

   // find the tile at the start position of the ray
   cx = coordsToTileX(start.x);
   cy = coordsToTileY(start.y);
    
   if(!inTileRange(cx, cy))
   {
    // outside of the tilemap
    result.x = start.x;
    result.y = start.y;
    return false;   
   }
    
   if(getTile(cx, cy) > 0)
   {
    // start point is inside a block
    result.x = start.x;
    result.y = start.y;
    return true;
   }

   if(maxTilesToCheck == -1)
   {
    // this number is large enough to guarantee that the ray will pass through the entire tile map
    maxTilesToCheck = int(widthInTiles * heightInTiles);
   }
    
   // determine step direction, and initial starting block
   if(direction.x > 0)
   {
    stepX = 1;
    outX = widthInTiles;
    cbx = x + (cx+1) * _tileWidth;
   }

   else
   {
    stepX = -1;
    outX = -1;
    cbx = x + cx * _tileWidth;
   }
   if(direction.y > 0)
   {
    stepY = 1;
    outY = heightInTiles;
    cby = y + (cy+1) * _tileHeight;
   }
   else
   {
    stepY = -1;
    outY = -1;
    cby = y + cy * _tileHeight;
   }

   // determine tMaxes and deltas
   if(direction.x != 0)
   {
    tMaxX = (cbx - start.x) / direction.x;
    tDeltaX = _tileWidth * stepX / direction.x;
   }
   else
    tMaxX = 1000000;
   if(direction.y != 0)
   {
    tMaxY = (cby - start.y) / direction.y;
    tDeltaY = _tileHeight * stepY / direction.y;
   }
   else
    tMaxY = 1000000;
    
   // step through each block  
   for(var tileCount:int=0; tileCount < maxTilesToCheck; tileCount++)
   {
    if(tMaxX < tMaxY)
    {
     cx = cx + stepX;
     if(getTile(cx, cy) > 0)
     {
      hitTile = true;
      break;
     }
     if(cx == outX)
     {
      hitTile = false;
      break;
     }
     tMaxX = tMaxX + tDeltaX;
    }
    else
    {
     cy = cy + stepY;
     if(getTile(cx, cy) > 0)
     {
      hitTile = true;
      break;
     }
     if(cy == outY)
     {
      hitTile = false;

      break;
     }
     tMaxY = tMaxY + tDeltaY;
    }
   }

   // result time
   tResult = (tMaxX < tMaxY) ? tMaxX : tMaxY;

   // store the result
   result.x = start.x + (direction.x * tResult);
   result.y = start.y + (direction.y * tResult);
   if(resultInTiles != null)
   {
    resultInTiles.x = cx;
    resultInTiles.y = cy;
   }

   return hitTile;
  }

  public function inTileRange(tileX:Number, tileY:Number):Boolean
  {
   return (tileX >= 0 && tileX < widthInTiles && tileY >= 0 && tileY < heightInTiles);
  }

  public function tileAt(coordX:Number, coordY:Number):uint
  {
   return getTile(Math.floor((coordX-x)/_tileWidth), Math.floor((coordY-y)/_tileHeight));
  }

  public function tileIndexAt(coordX:Number, coordY:Number):uint
  {
   var X:uint = Math.floor((coordX-x)/_tileWidth);
   var Y:uint = Math.floor((coordY-y)/_tileHeight);
   return Y * widthInTiles + X;
  }

  /**
205
   *
206
   * @param X in tiles
207
   * @param Y in tiles
208
   * @return
209
   *
210
   */
/*
  public function getTileIndex(X:uint, Y:uint):uint
  {
   return Y * widthInTiles + X;

  }

  public function coordsToTileX(coordX:Number):Number

  {
   return Math.floor((coordX-x)/_tileWidth);
  }
  public function coordsToTileY(coordY:Number):Number
  {
   return Math.floor((coordY-y)/_tileHeight);
  }

   
  public function indexToCoordX(index:uint):Number
  {
   return (index % widthInTiles) * _tileWidth + _tileWidth/2;
  }
  public function indexToCoordY(index:uint):Number
  {
   return Math.floor(index / widthInTiles) * _tileHeight + _tileHeight/2;
  }
*/