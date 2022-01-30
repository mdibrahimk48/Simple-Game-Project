/*
		ID- 182-16-326
			Game Analysis and Development, Spring - 2019
*/

package  {
	
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MorphShape;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.media.Sound;
	import flash.events.TimerEvent;
	import fl.motion.AdjustColor;
	import flash.net.SharedObject;
	import flash.system.fscommand;
	
	public class Main extends MovieClip {
		
		private var bg:MovieClip;
		private var nin:MovieClip;
		private var title:MovieClip;
		private var play_btn:MovieClip;
		private var how_btn:MovieClip;
		private var abt_btn:MovieClip;
		private var exit_btn:MovieClip;
		private var how_mc:MovieClip;
		private var abt_mc:MovieClip;
		private var selector:MovieClip;
		private var hero_mc:MovieClip;
		private var game_bg:MovieClip;
		private var hero_speed_x:Number = 10;
		private var hero_speed_y:Number = 9.8;
		private var movingUp:Boolean;
		private var selected_hero:int;
		private var total_distance:Number;
		private var obstacles:Array;
		private var creation_timer:Timer;
		private var timer:Timer;
		private var initialCreationDelay:int = 1000;
		private var creationDelay:int = 500;
		private var lives:int;
		
		private var rollars:Array;
		private var rollarSpeed:Number = 3;
		private var rollar2Speed:Number = 8;
		//private var rollar3Speed:Number = 11;
		
		private var score:int;
		private var rollarTakenTotal:int;
		private var highestRollarTaken:int;
		private var so:SharedObject;
		
		private var txt_score:TextField;
		private var txt_format:TextFormat;
		private var g_over:MovieClip;
		
		 
		public function Main() {
			trace('Bismillah....');

			//stage.scaleMode = stage.scaleMode.EXACT_FIT;
			
			so = SharedObject.getLocal('ninja');
			if(so.data['highestRollarTaken'] != undefined){
				highestRollarTaken = so.data['highestRollarTaken'];
			}else{
				so.data['highestRollarTaken'] = 0;
				so.flush(0);
			}
			
			trace(highestRollarTaken);
			
			
			creation_timer = new Timer(initialCreationDelay);
			creation_timer.addEventListener(TimerEvent.TIMER,createNewObstacle);
			
			timer = new Timer(creationDelay);
			timer.addEventListener(TimerEvent.TIMER,createNewRollar);
			
			movingUp = false;
			bg = new Bg();
			this.addChild(bg);
			
			title = new Title();
			this.addChild(title);
			//this.x = -title.width;
			title.y = 60;
			
			nin = new Ninja();
			this.addChild(nin);
			nin.x = -nin.width;
			nin.scaleX = nin.scaleY = 0.6;
			nin.y = 100;
			
			play_btn = new PlayBtn();
			this.addChild(play_btn);
			play_btn.x = -play_btn.width;
			play_btn.y = 200;
			play_btn.addEventListener(MouseEvent.CLICK,showHeroSelector);
			
			how_btn = new HowPlayBtn();
			this.addChild(how_btn);
			how_btn.x = -how_btn.width;
			how_btn.y = play_btn.y+play_btn.height+30;
			how_btn.addEventListener(MouseEvent.CLICK,showInstruction);
			
			abt_btn = new AboutBtn();
			this.addChild(abt_btn);
			abt_btn.x = -abt_btn.width;
			abt_btn.y = how_btn.y+how_btn.height+30;
			abt_btn.addEventListener(MouseEvent.CLICK,showAbout);
			
			exit_btn = new ExitBtn();
			this.addChild(exit_btn);
			exit_btn.x = -exit_btn.width;
			exit_btn.y = abt_btn.y+abt_btn.height+30;
			exit_btn.addEventListener(MouseEvent.CLICK, exitMtd);
			
			
			txt_score = new TextField();
			addChild(txt_score);
			txt_score.x = 1000;
			txt_score.width = 136;
			txt_score.visible = false;
			
			g_over = new Scoremc();
			this.addChild(g_over);
			g_over.visible = false;
			g_over.replay_btn.addEventListener(MouseEvent.CLICK,replayTheGame);
			
			txt_format = new TextFormat('Arial',24,0xff0000);
			txt_score.setTextFormat(txt_format);
			txt_score.defaultTextFormat = txt_format;
			
			how_mc = new HowToPlayMc();
			this.addChild(how_mc);
			how_mc.visible = false;
			how_mc.ok_btn.addEventListener(MouseEvent.CLICK,hideInstruction);
			
			
			abt_mc = new AboutMc();
			this.addChild(abt_mc);
			abt_mc.visible = false;
			abt_mc.ok_btn.addEventListener(MouseEvent.CLICK,hideAbout);
			
			
			selector = new HeroSelector();
			this.addChild(selector);
			selector.visible = false;
			selector.hero_1_mc.addEventListener(MouseEvent.CLICK,heroSelected);
			selector.hero_2_mc.addEventListener(MouseEvent.CLICK,heroSelected);
			selector.hero_3_mc.addEventListener(MouseEvent.CLICK,heroSelected);
			
			Tweener.addTween(title,{x:stage.stageWidth-title.width-20,time:2});
			Tweener.addTween(play_btn,{x:stage.stageWidth-play_btn.width-20,time:2,delay:1});
			Tweener.addTween(how_btn,{x:stage.stageWidth-how_btn.width-20,time:2,delay:1.5});
			Tweener.addTween(abt_btn,{x:stage.stageWidth-abt_btn.width-20,time:2,delay:2});
			Tweener.addTween(exit_btn,{x:stage.stageWidth-exit_btn.width-20,time:2,delay:2.5});
			Tweener.addTween(nin,{x:0,time:2,delay:2});
			
		}
		
		private function showInstruction(e:MouseEvent):void{
			how_mc.visible = true;
		}
		private function hideInstruction(e:MouseEvent):void{
			how_mc.visible = false;
		}
		private function showAbout(e:MouseEvent):void{
			abt_mc.visible = true;
		}
		private function exitMtd(e:MouseEvent):void{
			fscommand("quit");
		}
		private function hideAbout(e:MouseEvent):void{
			abt_mc.visible = false;
		}
		private function showHeroSelector(e:MouseEvent):void{
			selector.visible = true;
		}
		private function heroSelected(e:MouseEvent):void{
			var heroName:String = e.currentTarget.name;
			var whichHero:int = parseInt(heroName.charAt(5));
			selected_hero = whichHero;
			
			var selectedHero:MovieClip = e.currentTarget as MovieClip;
			var currentRotation:int = selectedHero.rotation;
			Tweener.addTween(selectedHero,{rotation:currentRotation+20,time:0.5});
			Tweener.addTween(selectedHero,{rotation:currentRotation,time:0.5,delay:0.6,onComplete:startGame});
		}
		private function mouseDownHandler(e:MouseEvent):void{
			movingUp = true;
		}
		private function mouseUpHandler(e:MouseEvent):void{
			movingUp = false;
		}
		private function startGame():void{
			selector.visible = false;
			play_btn.visible = false;
			how_btn.visible = false;
			title.visible = false;
			nin.visible = false;
			bg.visible = false;
			txt_score.visible = true;
			
			rollars = [];
			creation_timer.start();
			timer.start();
			total_distance = 0;
			score = 0;
			rollarTakenTotal = 0;
			obstacles = [];
			lives = 3;
			
			if(!game_bg){
				game_bg = new MovingBg();
				this.addChild(game_bg);
			}
			
			
			if(!hero_mc){
				hero_mc = new Hero();
				this.addChild(hero_mc);
				hero_mc.scaleX = hero_mc.scaleY = 0.6;
				hero_mc.x = (hero_mc.width/2)+100;
				hero_mc.y = (hero_mc.height/2)+50;
			}
			
			hero_mc.h1.visible = hero_mc.h2.visible = hero_mc.h3.visible = false;
			hero_mc['h'+selected_hero].visible = true;
			creation_timer.start();
			addChild(txt_score);
			txt_score.text = 'Score: '+score;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			this.addEventListener(Event.ENTER_FRAME,efg);
		}
		
		private function createNewRollar(e:TimerEvent):void{
			var rol:MovieClip;
			if(Math.random()>0.5){
				rol = new Rollar1();
				rol.scaleX = rol.scaleY = 0.4;
				rol.speedX = rollarSpeed;
				//rol.score = -10;
			}else if (Math.random()>0.5){
				rol = new Rollar2();
				rol.scaleX = rol.scaleY = 0.4;
				rol.speedX = rollar2Speed;
				//rol.score = 1;
			}else{
				rol = new Rollar3();
				rol.scaleX = rol.scaleY = 0.4;
				rol.speedX = rollar2Speed;
			}
			game_bg.addChild(rol);
			rol.x = stage.stageWidth+rol.width;
			rol.y = Math.random()*640;
			rollars.push(rol);
		}
		
		private function createNewObstacle(e:TimerEvent):void{
			var obsUp:MovieClip = new ObstacleUp();
			addChild(obsUp);
			obsUp.x = stage.stageWidth+obsUp.width;
			obsUp.y = (-(Math.random()*100))-100;
			obstacles.push(obsUp);
			
			var obsDown:MovieClip = new ObstacleDown();
			addChild(obsDown);
			obsDown.x = stage.stageWidth+obsDown.width;
			obsDown.y = -(Math.random()*100)+120;
			obstacles.push(obsDown);
			
			addChild(txt_score);
		}
		
		private function makeHeroOpaque():void{
			hero_mc.alpha = 1;
		}
		
		private function showScoreboard():void{
			addChild(g_over);
			g_over.visible = true;
			g_over.txt.text = 'Final Score: '+score;
		}
		
		private function replayTheGame(e:MouseEvent):void{
			var numRollars:int = rollars.length;
			for(var r:int=0;r<numRollars;r++){
				var rol:MovieClip = rollars[0] as MovieClip;
				rol.parent.removeChild(rol);
				rollars.splice(0,1);
			}
			
			var len:int = obstacles.length;
			for(var i:int=0;i<len;i++){
				try{
				var ob:MovieClip = obstacles[0] as MovieClip;
				ob.parent.removeChild(ob);
				obstacles.splice(0,1);
				}catch(e:Error){}
			}
			g_over.visible = false;
			startGame();
			//hero_mc.filters = [new AdjustColor];
		}
		
		private function playSound(soundName:String):void{
			var cls:Class = getDefinitionByName(soundName) as Class;
			var snd:Sound = new cls();
			snd.play();
		}
		
		private function efg(e:Event):void{
			game_bg.x-=hero_speed_x;
			total_distance+=hero_speed_x;
			if(game_bg.x<-1136){
				game_bg.x = 0;
			}
			
			if(movingUp && hero_mc.y>hero_mc.height/2){
				hero_mc.y-=hero_speed_y;
			}else if(!movingUp && hero_mc.y<stage.stageHeight-hero_mc.height/2){
				hero_mc.y+=hero_speed_y;
			}
			

			
			for(var i:int=0;i<obstacles.length;i++){
				var o:MovieClip = obstacles[i] as MovieClip;
				o.x-=hero_speed_x;
				
				if((hero_mc.hit_mc.hitTestObject(o) || hero_mc.hit_mc.hitTestObject(o)) && hero_mc.hit_mc.alpha ==1){
					hero_mc.alpha = 0.5;
					lives--;
					playSound('HitSound');
					
					
				
					if(lives == 0){
						//if(score<0){
							if(rollarTakenTotal>highestRollarTaken){
								so.data['highestRollarTaken'] = rollarTakenTotal;
								so.flush(0);
							}
						this.removeEventListener(Event.ENTER_FRAME,efg);
						this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
						this.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
						showScoreboard();
						g_over.highscore_txt.text = so.data['highestRollarTaken'];
						return;
					}
					
					setTimeout(makeHeroOpaque,500);
					hero_mc.filters = [new GlowFilter];
				}
			//}
				
				if(o.x <= -o.width){
					score++;
					txt_score.text = 'Score: '+score;
					removeChild(o);
					obstacles.splice(i,1);
					i--;
				}
			}
			
			for(var sp:int=0;sp<rollars.length;sp++){
				var rol:MovieClip = rollars[sp] as MovieClip;
				rol.x-=4+rol.speedX;
				
				
				if(rol.x<-rol.width){
					rol.parent.removeChild(rol);
					rollars.splice(sp,1);
					sp--;

				}
			}
		}
	}
}