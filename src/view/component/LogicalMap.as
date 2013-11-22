package view.component
{
	import com.astar.basic2d.Map;
	import com.astar.basic2d.analyzers.FullClippingAnalyzer;
	import com.astar.core.Astar;
	import com.astar.core.AstarEvent;
	import com.astar.core.PathRequest;
	import com.astar.expand.ItemTile;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import global.DC;
	
	import view.unit.Walker;

	/**
	 * 逻辑地图层
	 * @author Administrator
	 */	
	public class LogicalMap extends Sprite
	{
		private var dataMap:Array;
		private var maxH:uint;
		private var maxV:uint;
		
		public function LogicalMap()
		{
			init();
		}
		
		private function init():void
		{
			vecNpc = new Vector.<Walker>();
			//解析xml配置数据
			parseMapXml();
			creatMap();
			initAstar();
		}
		
		
		private var astar:Astar;
		private var req:PathRequest;
		private function initAstar():void
		{
			//create the Astar instance and add the listeners
			astar = new Astar();
			astar.addAnalyzer(new FullClippingAnalyzer());
			astar.addEventListener(AstarEvent.PATH_FOUND, onPathFound);
			astar.addEventListener(AstarEvent.PATH_NOT_FOUND, onPathNotFound);
		}
		
		private var map:Map;
		private function creatMap():void
		{
			var tile:ItemTile;
			var item:LogicalRect;
			const w:uint = LogicalRect.ITEM_WIDTH;
			const h:uint = LogicalRect.ITEM_HEIGHT;
			map = new Map(maxH, maxV);
			map.heuristic = Map.MANHATTAN_HEURISTIC;
			
			for(var y:Number = 0; y< maxV; y++)
			{
				for(var x:Number = 0; x< maxH; x++)
				{
					tile = new ItemTile(1, new Point(x,y), (dataMap[y][x]==0));
					map.setTile(tile);
					item = new LogicalRect(tile);
					item.setPositionText(x, y);
					item.x = w/2 + x*w;
					item.y = h/2 + y*h;
					this.addChild( item );
				}
			}
		}
		
		private function parseMapXml():void
		{
			//解析地图通行数据
			var source:Object = DC.instance().mapObj;
			const max:uint = source.length;
			var char:String;
			var arr:Array = [];
			dataMap = [];
			for(var i:int = 0;i<max;i++)
			{
				char = source.charAt(i);
				if(char == "|")
					continue;
				if(char == "●")		//换行
				{
					dataMap.push( arr );
					arr = [];
				}
				else if(char == "0"||char=="1")
				{
					arr.push(uint(char));
				}
			}
			dataMap.push( arr );
			maxH = arr.length;
			maxV = dataMap.length;
			trace(maxH, maxV);
		}
		
		private function onPathNotFound(event : AstarEvent) : void
		{
			trace("path not found");
			vecNpc.pop();
		}
		
		private function onPathFound(e : AstarEvent) : void
		{
			trace("Path was found: ");
//			for(var i:int = 0;i<e.result.path.length;i++)
//			{
//				trace((e.result.path[i] as ItemTile).getPosition());
//			}
			var walker:Walker = vecNpc.shift();
			walker.startMove(e.result.path);
		}
		/**
		 * 通过行列位置查找tile
		 * @param point
		 * @return 
		 * 
		 */		
		public function getTileByPosition(point:Point):ItemTile
		{
			return map.getTileAt(point) as ItemTile;
		}
		
		private var vecNpc:Vector.<Walker>;
		public function moveBody(npc:Walker, target:ItemTile):void
		{
			if(!target.getWalkable() || npc.getCrtTile() == target || npc.isCrtPathEnd(target))
				return;
			vecNpc.push( npc );
			npc.pause();
			//create a new PathRequest
			req = new PathRequest(npc.getCrtPathEnd(), target, map);
			//a general analyzer
			astar.getPath(req);
		}
		
		/**
		 * 通过坐标找到其相对应tile对象
		 * @param point
		 * @return 
		 */		
		public function getTileByMousePlace(point:Point):ItemTile
		{
			var w:uint = LogicalRect.ITEM_WIDTH;
			var h:uint = LogicalRect.ITEM_HEIGHT;
			var tx:int = point.x / w;
			var ty:int = point.y / h;
			var p:Point = new Point(Math.round(tx), Math.round(ty));
			return map.getTileAt(p) as ItemTile;
		}
		
		private static var _instance:LogicalMap;
		public static function getInstance():LogicalMap
		{
			if(!_instance)
				_instance = new LogicalMap();
			return _instance;
		}
		
		public static const POSITION_INTO_SHOP:Point = new Point(3, 5);
		public static const POSITION_OUT_SHOP:Point = new Point(3, 5);
		public static const POSITION_PAY:Point = new Point(8, 7);
		public function get TITLE_INTO_SHOP():ItemTile
		{
			return _instance.getTileByPosition( POSITION_INTO_SHOP );
		}
		public function get TITLE_OUT_SHOP():ItemTile
		{
			return _instance.getTileByPosition( POSITION_OUT_SHOP );
		}
		public function get TITLE_PAY():ItemTile
		{
			return _instance.getTileByPosition( POSITION_PAY );
		}
	}
}