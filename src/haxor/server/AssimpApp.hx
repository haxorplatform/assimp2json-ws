package haxor.server;

import haxor.server.AssimpController;
import js.Error;
import js.Node;
import js.node.ChildProcess;
import js.RegExp;
import nws.Application;
import nws.view.View;
import nws.model.Model;

class AssimpApp extends ApplicationMVC<Model,View,AssimpController>
{
	/**
	 * Entry point.
	 */
	static function main():Void { new AssimpApp(); }
	
	
	
	/**
	 * Entry point.
	 */
	override public function OnInitialize():Void 
	{			
		controller = cast AddComponent(AssimpController);
	}	
	
}