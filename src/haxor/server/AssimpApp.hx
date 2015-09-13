package haxor.server;

import haxor.server.AssimpController;
import js.Error;
import js.Node;
import js.node.ChildProcess;
import js.RegExp;
import nws.Application;
import nws.view.View;
import nws.model.Model;

import js.node.child_process.ChildProcess as ChildProcessObject;

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
	private function get_unix():Bool { return !(new RegExp("^win").test(Node.process.platform)); }
	
	/**
	 * Entry point.
	 */
	override public function OnInitialize():Void 
	{			
		controller = cast AddComponent(AssimpController);				
	}	
	
}