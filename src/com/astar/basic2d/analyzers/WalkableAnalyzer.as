﻿/*
Copyright (c) 2011 Jeroen Beckers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.astar.basic2d.analyzers
{
	import com.astar.basic2d.IWalkableTile;
	import com.astar.core.Analyzer;
	import com.astar.core.IAstarTile;
	import com.astar.core.PathRequest;
	

	/**
	 * The WalkableAnalyzer eliminates tiles that aren't walkable. If ignoreEnd is true, the end node (PathRequest.isTarget(tile)) doesnt have to be walkable
	 * @author Jeroen
	 */
	public class WalkableAnalyzer extends Analyzer {
		private var _ignoreEnd:Boolean;
		public function WalkableAnalyzer(ignoreEnd:Boolean = false) {
			super();
			_ignoreEnd = ignoreEnd;
		}

		override public function analyzeTile(tile: IAstarTile, req:PathRequest):Boolean
		{
			if(_ignoreEnd && (req.isTarget(tile))) return true;
			
			return (tile as IWalkableTile).getWalkable();	
		}
		
		override protected function analyze(mainTile : IAstarTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, req:PathRequest) : Vector.<IAstarTile>
		{
			var newLeft:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			for(var i:Number = 0; i<neighboursLeft.length; i++)
			{
				var currentTile : IAstarTile = neighboursLeft[i];
				if((currentTile as IWalkableTile).getWalkable() || (_ignoreEnd && req.isTarget(currentTile))) newLeft.push(currentTile);
			}
			return newLeft;
		}
	}
}
