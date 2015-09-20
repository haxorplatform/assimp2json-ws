package haxor.server;


import js.Error;
import js.Node;
import js.node.ChildProcess;
import js.RegExp;
import nws.Application;
import nws.component.net.HttpComponent;
import nws.view.View;
import nws.model.Model;

class AssimpApp extends Application
{
	/**
	 * Entry point.
	 */
	static function main():Void { new AssimpApp(); }
	
	/**
	 * Reference to the Http server.
	 */
	public var http : HttpComponent;
	
	/**
	 * Entry point.
	 */
	override public function OnInitialize():Void 
	{	
		Log("Created.");
		//Must be added in the root for event propagating.		
		http = cast AddComponent(HttpComponent);
		http.Listen(9090);		
		CreateChild("convert", ConvertService);
	}	
	
}