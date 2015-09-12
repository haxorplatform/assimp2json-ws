package haxor.server;

import nws.component.net.HttpComponent;
import nws.controller.Controller;


class ControllerContainer extends Controller
{
	
	/**
	 * Reference to the Http server.
	 */
	public var http : HttpComponent;
	
	/**
	 * Container of all services.
	 */
	public var service : ServiceController;
	
	/**
	 * Callback called upon creation.
	 */
	override public function OnCreate():Void 
	{
		//Must be added in the root for event propagating.
		http = cast entity.AddComponent(HttpComponent);
		http.Listen(5000);
		
		service = cast entity.AssertChild("service", ServiceController);
	}
	
	/**
	 * Reference to the main application.
	 */
	public var assimp(get, never):AssimpApp;
	private function get_assimp():AssimpApp { return cast app; }
	
}