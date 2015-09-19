package haxor.server;


import haxe.Timer;
import js.Node;
import js.node.Buffer;
import js.node.fs.ReadStream;
import js.node.http.IncomingMessage;
import js.node.http.Method;
import js.node.http.Server;
import js.node.http.ServerResponse;
import js.Error;
import haxe.Json;
import js.node.Url;
import nws.component.net.HttpSession;
import js.node.ChildProcess;

import js.node.Fs;
import nws.controller.service.Service;
/**
 * ...
 * @author Henrique Dias - henrique@gemeos.org
 */
class ConvertService extends Service
{

	/**
	 * Reference to the main application.
	 */
	public var assimp(get, never):AssimpApp;
	private function get_assimp():AssimpApp { return cast app; }
	
	/**
	 * Path to the process.
	 */
	public var process(get, never):String;	
	private function get_process():String { return assimp.unix ? "../../assimp2json/bin/assimp2json" : ""; }
	
	public var cmd(get, never):String;	
	private function get_cmd():String { return assimp.unix ? "sh" : "assimp2json.exe"; }
	
	public var args(get, never):Array<String>;	
	private function get_args():Array<String> { return assimp.unix ? ["-c",process] : []; }
		
	/**
	 * Init.
	 */
	override public function OnCreate():Void 
	{		
		route = new EReg("/convert", "");
		
		persistent = true;
	}
	
	@route("post,options", "/$")	
	function Convert():Void
	{		
		var s : HttpSession = session;	
		var b : Buffer 		= s.data.buffer;
		var err : Error 	= null;		
		
		if (s.method == Method.Options)
		{
			s.response.setHeader("Access-Control-Allow-Origin", "*");
			s.response.end();
			return;
		}
		
		if (b == null)
		{
			Log("[error] null buffer");
			err = new Error("null buffer"); err.name = "invalid-buffer";
			s.response.write("false");
			s.http.Throw(err, 500);
		}
		else
		{
			var header  	: String 		= GetFileHeader(b, 1024);
			var data    	: Buffer 		= b.slice(header.length+1);			
			var tks     	: Array<String> = header.split(",");					
			var file_path 	: String 		= tks.length >= 1 ? tks[0] : null;
			
			Log("input[" + b.length + "]");
			Log("header[" + header + "]["+header.length+"]");
			Log("buffer[" + data.length + "]");
			
			
			RunAssimp(file_path, data, function(p_file_name:String,p_result:Buffer,p_code:Int, p_error:Error):Void
			{
				if (p_error != null)
				{
					Log(p_error);
					s.response.write("fail");
					s.response.end();
				}
				else
				{
					Log("Assimp Complete id["+(untyped s.response.__id__)+"] code["+p_code+"] length["+p_result.length+" bytes]");					
					s.response.setHeader("Content-disposition", "attachment; filename='"+p_file_name+".json'");
					s.response.setHeader("Content-type", "application/json");
					s.response.setHeader("Content-Length", p_result.length + "");				
					s.response.write(p_result);
					s.response.end();
				}
			});
			
		}
		
	}

	@route("get", "/test")	
	public function TestAssimp(test=false):Bool
	{	
			var s : HttpSession = session;
			var filename : String = "../../assimp2json/samples/spider.obj";
			if (test) filename = "./assimp2json/samples/spider.obj";
			var data : Buffer = Fs.readFileSync(filename);

			RunAssimp("spider.obj", data, function(p_file_name:String,p_result:Buffer,p_code:Int, p_error:Error):Void
			{
				if (p_error != null)
				{
					Log(p_error);
					s.response.write("fail");
					s.response.end();
				}
				else
				{
					Log("Assimp Complete id["+(untyped s.response.__id__)+"] code["+p_code+"] length["+p_result.length+" bytes]");			
					s.response.write(p_result);
					s.response.end();
				}
			});

			return true;

	}
	/**
	 * Run Assimp Daemon
	 * @param	p_file_path
	 * @param	p_data
	 * @param	p_callback
	 */
	private function RunAssimp(p_file_path:String, p_data:Buffer,p_callback:String->Buffer->Int->Error->Void):Void
	{
		var file_path : String = p_file_path;
		var file_name : String = file_path.indexOf("/") >=0 ? (file_path.split("/").pop()) : file_path;
		var file_ext  : String = "";
		if (file_name.indexOf(".") >= 0)
		{			
			file_ext  = file_name.split(".")[1];
			file_name = file_name.split(".")[0];
		}
		
		if (file_name == null) file_name = "JsonModel"; else if (file_name == "") file_name = "JsonModel";
		
		file_name = file_name+".json";
		
		var tmp_file : String = GetTempName()+"."+file_ext;
		
		Fs.writeFile(tmp_file, p_data, { }, function(p_error:Error):Void
		{
			if (p_error != null)
			{
				p_callback(file_name,null,1, p_error);
			}
			else
			{
				var arg_list : Array<String> = args; 
				arg_list.push(tmp_file);
								
				var exists : Bool = Fs.statSync(tmp_file).isFile();
				
				Log("Converting args["+arg_list.join(",")+"] path["+file_path+"] to["+file_name+"] exists["+exists+"]",1);
		
				//Default limit is 8k
				var opt : ChildProcessExecOptions = cast { maxBuffer: 1024 * 1024 * 500 };
				
				ChildProcess.execFile(cmd, ["-c",process + " " + tmp_file], opt, function(p_error:ChildProcessExecError, p_stdout:Dynamic, p_stderr:Dynamic):Void
				{
					if (p_error == null) {	
						p_callback(file_name, p_stdout, 0, null);

						Timer.delay(function()
						{
							Fs.unlink(tmp_file, function(p_error:Error):Void
							{
								if (p_error != null)
								{
									Log(p_error);
								}					
							});
						},5);

					} else {
						Log("error : " + Json.stringify(p_error));
						Log("stderr: " + Json.stringify(p_stderr));
						Log("stdout: " + Json.stringify(p_stdout));
						p_callback(file_name,null,1, p_error);	
					}
				});

			}			
		});
	}

	/**
	 * Generates a temp filename.
	 * @return
	 */
	public function GetTempName():String
	{			
		var d  : Int = untyped Math.floor((Date.now() - Date.fromTime(0)) / 1000);
		var r0 : Int = Math.floor(Math.random()*0xfffffff);
		var r1 : Int = Math.floor(Math.random()*0xfffffff);
		var r2 : Int = Math.floor(Math.random()*0xfffffff);		
		var t  : Int = Math.floor(Timer.stamp());
		var b0 : String = StringTools.hex(r0 + t,6);	//Counter starting at random
		var b1 : String = StringTools.hex(r1,4);		//Process Id
		var b2 : String = StringTools.hex(r2,6);		//Machine Identifier
		var b3 : String = StringTools.hex(d, 8); 		//Unix Time				
		b0 = b0.substr(b0.length - 6, 6);
		b1 = b1.substr(b1.length - 4, 4);
		b2 = b2.substr(b2.length - 6, 6);
		b3 = b3.substr(b3.length - 8, 8);					
		return (b0 + b1 + b2 + b3).toLowerCase();
	}
	
	/**
	 * Extracts initial information from the buffer.
	 * @param	p_data
	 * @param	p_max_len
	 * @return
	 */
	public function GetFileHeader(p_data:Buffer,p_max_len:Int=-1):String
	{
		var h : String = "";
		var len : Int = p_max_len < 0 ? p_data.length : p_max_len;
		for (i in 0...len)
		{			
			if (p_data[i] != 0) h += String.fromCharCode(p_data[i]); else break;
		}
		return h;
	}
	
	
}