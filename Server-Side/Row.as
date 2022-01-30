package  {
	
	import flash.display.MovieClip;

	
	public class Row extends MovieClip {
		
		public var user_name:String;
		private var score:int;
		
		public function Row(theName:String,theScore:int) {
			user_name = theName;
			score = theScore;
			name_txt.text = user_name;
			score_txt.text = score+'';
		}
		
		public function getUsername():String{
			return user_name;
		}
		public function getUserscore():int{
			return score;
		}
		public function set userscore(newScore:int):void{
			score = newScore;
		}
		public function set username(newName:String):void{
			user_name = newName;
			name_txt.text = user_name;
		}
	
	
	}
	
}
