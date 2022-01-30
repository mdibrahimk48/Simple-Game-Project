package  {
	
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.events.ProgressEvent;
	
	public class Main extends MovieClip {			
		private var gw:NetConnection;
		private var getTopScores_responder:Responder;
		private static var gateway_url:String = 'http://localhost/game/amfphp/';		
		private var snd_url:String = 'http://localhost/game/person_sound.mp3';
		
		public function Main() {
			// constructor code
			trace('Bismillah...');
			gw = new NetConnection();
			gw.connect(gateway_url);
			
			getTopScores_responder = new Responder(getTopScores_responder_success,getTopScores_responder_failed);
			
			gw.call('GameService.getTopScores',getTopScores_responder);
			
			
		}
		private function getTopScores_responder_success(res:Array):void{
			for(var i:int=0;i<res.length;i++){
				var row:Row = new Row(res[i][0],res[i][1]);
				addChild(row);
				row.y = row.height*i;
			}
		}
		private function getTopScores_responder_failed(err:Object):void{
			trace(err);
		}
	}
	
}
