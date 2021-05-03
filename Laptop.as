package {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.SoundMixer;

	public class Laptop extends MovieClip {

		var current = new Date();
		var minuteI = current.getMinutes();
		var minute = String;
		var hours = current.getHours();
		var m = MovieClip(root).game;
		var yesnoCase: int = 0;
		var timer: int = 200;
		var c_loading: String;
		var c_stats: String;
		var c_master: String;
		var installed = false;

		public function Laptop() {
			addEventListener(Event.ENTER_FRAME, loop);

			exit.addEventListener(MouseEvent.CLICK, leave);
			line.addEventListener(MouseEvent.CLICK, doLine);
			netflix.addEventListener(MouseEvent.CLICK, doNetflix);
			rstudio.addEventListener(MouseEvent.CLICK, doRstudio);
			word.addEventListener(MouseEvent.CLICK, doWord);
			asako.addEventListener(MouseEvent.CLICK, doAsako);
			apps.close.addEventListener(MouseEvent.CLICK, doClose);

			yes.addEventListener(MouseEvent.CLICK, doYes);
			no.addEventListener(MouseEvent.CLICK, doClose);

			apps.gotoAndStop("normal");

			invis();
			tyes.mouseEnabled = false;
			tno.mouseEnabled = false;
			
			gameIcon.visible = false;
			asako.visible = false;
		}
		function loop(e: Event): void {
			
			if(m.day == 28 && !installed){
				lineIcon.gotoAndStop(2);
			} else {
				lineIcon.gotoAndStop(1);
			}
			
			if(installed && timer == 99){
				gameIcon.visible = true;
				asako.visible = true;
			}
			
			today.text = String(m.day);
			if (minuteI < 10) {
				minute = String("0" + minuteI);
			} else {
				minute = minuteI;
			}
			time.text = hours + ":" + minute;
			
			//loading
			if (timer < 100) {
				loading.gotoAndStop(2);
				loading.t_loading.text = c_loading;
				loading.t_stats.text = c_stats;
				loading.t_master.text = c_master;
				timer++;
				loading.bar.scaleX = timer/100;
			} else {
				c_loading = "";
				c_stats = "";
				c_master = "";
				loading.gotoAndStop(1);
			}
			
			
			
		}
		function leave(e: MouseEvent): void {
			if (apps.currentLabel == "normal") {
				m.laptopMode = false;
				m.paused = false;
			}

		}
		function doLine(e: MouseEvent): void {
			apps.gotoAndStop("line");
			if(m.day == 28){
				apps.chat.gotoAndStop(2);
				if(!installed){
					installed = true;
					timer = 0;
					c_loading = "Installing game";
				}
			} else {
				apps.chat.gotoAndStop(1);
			}
			
		}
		function doNetflix(e: MouseEvent): void {
			apps.gotoAndStop("netflix");
			if(m.culture > 99){
				vis(9);
			} else if (m.energy < 30) {
				vis(5);
			}  else if (m.hunger < 1) {
				vis(7)
			} else {
				vis(4);
			}
		}
		function doRstudio(e: MouseEvent): void {
			apps.gotoAndStop("rstudio");
			if(m.intelligence > 99){
				vis(8);
			} else if (m.energy < 20) {
				vis(5);
			} else if (m.fun < 10) {
				vis(6);
			} else if (m.hunger < 1) {
				vis(7)
			} else {
				vis(3);
				
			}
		}
		function doWord(e: MouseEvent): void {
			apps.gotoAndStop("word");
			if(m.master > 99){
				vis(10);
			} else if (m.energy < 30) {
				vis(5);
			} else if (m.fun < 10) {
				vis(6);
			} else if (m.hunger < 1) {
				vis(7)
			} else {
				vis(2);
			}
		}
		function doAsako(e: MouseEvent): void {
			apps.gotoAndStop("game");
		}
		function doClose(e: MouseEvent): void {
			apps.gotoAndStop("normal");
			invis()
			SoundMixer.stopAll();

		}

		function doYes(e: MouseEvent): void {
			
			invis()
			m.doYesno(yesnoCase);
			switch (yesnoCase) {
				case 2: // master thesis
					timer = 0;
					c_stats = "+" + m.masterDisplay + " effort!";
					c_master = m.master + "% Complete"
					c_loading = "書いてる";
					break;
				case 3: // rstudio
					timer = 0;
					c_stats = "+" + m.intelligenceDisplay + " Intelligence!";
					c_loading = "勉強中";
					break;
				case 4: // netflix
					var random:int = 3+Math.floor( Math.random() * 4)
					trace(random);
					var random2: int = 1+Math.floor( Math.random() * 5)
					apps.player.gotoAndStop(random);
					if(random == 6){
						apps.player.himym.chance.gotoAndStop(random2);
					}
					apps.player.t_culture.text = m.cultureDisplay;
					apps.player.t_fun.text = m.funDisplay;
					break;
			}
			
		}

		function vis(app: int): void {
			yesnoCase = app;
			dialog.gotoAndStop(app);
			no.visible = true;
			dialog.visible = true;
			tno.visible = true;
			if (app < 5) {
				if(app == 2){
					tyes.text = "書く";
					tno.text = "書かない";
				} else if(app == 3){
					tyes.text = "する";
					tno.text = "しない";
				}
				yes.visible = true;
				tyes.visible = true;
			} else {
				tno.text = "閉じる";
			}
		}
		function invis(): void {
			yes.visible = false;
			no.visible = false;
			dialog.visible = false;
			tyes.visible = false;
			tno.visible = false;
		}


	}

}