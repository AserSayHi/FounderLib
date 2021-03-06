package global
{
	public class DC
	{
		private static var _instance:DC;
		public static function instance():DC
		{
			if(_instance == null)
				_instance = new DC();
			return _instance;
		}
		
		public function DC()
		{
		}
		
		public var shelfObj:Object;
		public var mapObj:Object;
		public var propObj:Object;
		
		public function getPropNameByID(id:String):String
		{
			for each(var obj:Object in propObj)
			{
				if(obj.id == id)
					return obj.name;
			}
			return null;
		}
	}
}