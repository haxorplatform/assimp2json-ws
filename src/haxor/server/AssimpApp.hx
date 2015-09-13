package haxor.server;

import haxor.server.AssimpController;
import js.Node;
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
	 * Flag that indicates the platform is unix.
	 */
	public var unix(get, never):Bool;
	private function get_unix():Bool { return  new RegExp("^win").test(Node.process.platform); }
	
	/**
	 * Entry point.
	 */
	override public function OnInitialize():Void 
	{	
		controller = cast AddComponent(AssimpController);		
		while (true){};
	}	
	
}