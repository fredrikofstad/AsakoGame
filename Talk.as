package {

	import flash.display.MovieClip;
	import flash.events.*;


	public class Talk extends MovieClip {
		var body: Array;
		var speech: String;
		var male: Boolean;

		var arrayPosition: int = 0;
		var textPosition: int = 0;
		var textSpeed: int = 1;
		var talking = false;
		var asking = false;
		var timer: int = 0;
		var safe: Boolean = false;
		var yes: String;
		var no: String;
		var yesnoCase: int;
		var qyes: Boolean = true;

		var m = MovieClip(root).game;


		public function Talk() {
			this.gotoAndStop("talk");
			addEventListener(Event.ENTER_FRAME, loop);
		}

		public function say(i_body: Array, i_male: Boolean = true): void {
			if (!talking && !safe && !MovieClip(root).game.paused) {
				this.gotoAndStop("talk");
				talking = true;
				MovieClip(root).game.paused = true;
				arrayPosition = 0;
				textPosition = 0;
				//inputs
				body = i_body;
				male = i_male;
				//setting up text
				speech = body[arrayPosition];
			}
		}

		public function ask(i_body: Array, i_yes: String = "する", i_no: String = "しない", i_yesnoCase: int = 0): void {
			if (!asking && !safe && !MovieClip(root).game.paused) {
				this.gotoAndStop("ask");
				t_yes.text = "";
				t_no.text = "";
				qyes = true;
				asking = true;
				MovieClip(root).game.paused = true;
				arrayPosition = 0;
				textPosition = 0;
				body = i_body;
				yes = i_yes;
				no = i_no;
				yesnoCase = i_yesnoCase;
				speech = body[arrayPosition];
			}

		}

		function loop(e: Event): void {
			if (timer > 0) {
				timer--;
				safe = true;
			} else {
				safe = false;
			}
			if (talking) {
				this.visible = true;

				t_body.text = speech.substr(0, textPosition);
				speech = body[arrayPosition];
				if (textPosition < speech.length) {
					textPosition += textSpeed;
					arrow.visible = false;
					/*if (male) {
						talksound.play();
					} else {
						talksound2.play();
					}*/

				} else {
					arrow.visible = true;
					if (MovieClip(root).game.spacePressed) {
						exit();
					}

				}
			} else if (asking) {
				this.visible = true;
				t_body.text = speech.substr(0, textPosition);
				speech = body[arrayPosition];
				if (textPosition < speech.length) {
					textPosition += textSpeed;
					arrow.visible = false;
				} else {
					arrow.visible = true;
					t_yes.text = yes;
					t_no.text = no;


					if (qyes) {
						arrow.gotoAndStop("yes");
						if (MovieClip(root).game.rightPressed) {
							qyes = false;
						}
					} else {
						arrow.gotoAndStop("no");
						if (MovieClip(root).game.leftPressed) {
							qyes = true;
						}
					}

					if (MovieClip(root).game.spacePressed) {
						if (qyes) {
							exit();
							MovieClip(root).game.doYesno(yesnoCase);
						} else {
							exit();
						}
					}

				}

			} else {
				this.visible = false;
				info.gotoAndStop(1);
			}

		}
		function exit(): void {
			safe = true;
			timer = 10;
			talking = false;
			asking = false;
			MovieClip(root).game.paused = false;

		}
	}

}