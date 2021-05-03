package {
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.net.SharedObject;
	import flash.desktop.NativeApplication;


	public class asakoGame extends MovieClip {

		//char movement
		private var speed: int = 15;
		private var rightBumping, leftBumping: Boolean = false;
		//game events
		public var paused: Boolean = false;
		//controls
		public var upPressed, downPressed, leftPressed, rightPressed, spacePressed: Boolean = false;

		//saveDAta
		var so: SharedObject = SharedObject.getLocal("asako");


		//house
		var currentSpace: int = 1;
		var entering: Boolean = false;
		//ui
		var uiOpen: Boolean = false;
		var fullScreen = true;

		//cutscenes
		public var laptopMode: Boolean = false;

		//////stats//////
		public var counter: int = 1;
		public var day: int = counter + 17;
		//stats etc
		var max: int = 100;
		var energy: int = 100;
		var hunger: int = 50;

		var fun: int = 80;
		var master: int = 0;

		var intelligence: int = 0;
		var culture: int = 0;
		var stamina: int = 0;

		public var hungerDisplay: int;
		public var funDisplay: int;
		public var masterDisplay: int;
		public var intelligenceDisplay: int;
		public var cultureDisplay: int;
		public var staminaDisplay: int;


		var percentEnergy: Number = energy / max;
		var percentHunger: Number = hunger / max;
		var percentFun: Number = fun / max;
		var percentMaster: Number = master / max;

		//clothing
		var costume: String = "normal";
		var sachioC: int = 1;
		var iriC: int = 3;

		//talking
		var talking: Boolean = false;
		var textBox: Talk;
		//cutscene
		var timer: int = 0;
		var currentFood = "thai";
		var title: Boolean = true;
		var foodCounter: int = 1;
		var eaten: Boolean = false;
		var sleeping: Boolean = false;

		var upA, downA, sideA: Boolean = false;

		//endings:
		var normalEnding: Boolean = false;
		var staminaEnding: Boolean = false;
		var cultureEnding: Boolean = false;
		var ministerEnding: Boolean = false;
		//flags
		var normalE: Boolean = false;
		var staminaE: Boolean = false;
		var cultureE: Boolean = false;
		var ministerE: Boolean = false;
		var endingHandler: Boolean = false;
		var currentEnding: int = 0;
		var finalGrade: String;


		public function asakoGame() {
			createGame();
		}

		function createGame(): void {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

			stage.addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			ui.hitbox.addEventListener(MouseEvent.CLICK, clickUi);

			gotoAndStop(1);
			loadGame();

			wall.gotoAndStop("bedroom");
			cs.gotoAndStop("title");

		}

		function loop(e: Event): void {

			//trace(paused);


			//cutscene handler
			if (timer > 0) {
				timer--;
				if (timer == 1) {
					cs.gotoAndStop("normal");
					paused = false;
				}
			}
			if (sleeping) {
				cs.gotoAndStop("sleep");
				if (cs.sleepy.currentLabel == "begin") {
					cs.sleepy.day.text = day - 1;
					cs.sleepy.left.text = 29 - day;
				} else if (cs.sleepy.currentLabel == "change") {
					cs.sleepy.day.text = day;
					cs.sleepy.left.text = 28 - day;
				} else if (cs.sleepy.currentLabel == "finish") {
					sleeping = false;
					paused = false;
					cs.gotoAndStop("normal");
				}

			}
			//ending handler
			if (endingHandler) {
				if (currentEnding == 1) {
					if (cs.endcs.kg.currentLabel == "gradeFrame") {
						cs.endcs.kg.grade.text = finalGrade;
					} else if (cs.endcs.kg.currentLabel == "choose") {
						if (ministerE) {
							cs.endcs.gotoAndStop("minister");
							currentEnding = 2;
						} else if (staminaE) {
							cs.endcs.gotoAndStop("sports");
							currentEnding = 2;
						} else if (cultureE) {
							cs.endcs.gotoAndStop("culture");
							currentEnding = 2;
						} else {
							cs.endcs.gotoAndStop("normal");
							currentEnding = 2;
						}
					}
				} else if (currentEnding == 2){
					if (cs.endcs.ending.currentLabel == "end") {
						if(spacePressed){
							NativeApplication.nativeApplication.exit();
						}
					}
				}
			}
			//food
			switch (foodCounter) {
				case 1:
					currentFood = "sushi";
					break;
				case 2:
					currentFood = "thai";
					break;
				case 3:
					currentFood = "tendon";
					break;
				case 4:
					currentFood = "curry";
					break;
				case 5:
					currentFood = "mapo";
					break;
				case 6:
					currentFood = "cake";
			}


			//title sequence
			if (cs.currentLabel == "title") {
				if (normalEnding) {
					cs.title.eNormal.gotoAndStop(2);
				} else {
					cs.title.eNormal.gotoAndStop(1);
				}
				if (staminaEnding) {
					cs.title.eTennis.gotoAndStop(2);
				} else {
					cs.title.eTennis.gotoAndStop(1);
				}
				if (cultureEnding) {
					cs.title.eCulture.gotoAndStop(2);
				} else {
					cs.title.eCulture.gotoAndStop(1);
				}
				if (ministerEnding) {
					cs.title.eMinister.gotoAndStop(2);
				} else {
					cs.title.eMinister.gotoAndStop(1);
				}
				title = true;
				paused = true;
				if (spacePressed) {
					cs.gotoAndStop("normal");
					paused = false;
					title = false;
				}
			}

			day = counter + 17;
			//stats loop
			if (energy > 100) {
				energy = 100;
			}
			if (hunger > 100) {
				hunger = 100;
			}
			if (fun > 100) {
				fun = 100;
			}
			if (energy < 0) {
				energy = 0;
			}
			if (hunger < 0) {
				hunger = 0;
			}
			if (fun < 0) {
				fun = 0;
			}
			if (master > 100) {
				master = 100;
			}
			if (culture > 100) {
				culture = 100;
			}
			if (intelligence > 100) {
				intelligence = 100;
			}
			if (stamina > 100) {
				stamina = 100;
			}

			//transition and pauses
			if (transition.currentLabel == "start") {
				paused = true;
			} else if (transition.currentLabel == "done") {
				paused = false;
			}

			if (currentSpace < 4) {
				if (l1.door.currentLabel == "done") {
					paused = false;
					if (entering) {
						currentSpace = 2;
					} else {
						currentSpace = 1;
					}

				}

				if (l2.door.currentLabel == "done") {
					paused = false;
					if (entering) {
						currentSpace = 3;
					} else {
						currentSpace = 2;
					}
				}
			}

			//collisions and interactivity
			if (currentSpace == 1) { //bedroom


				//bed
				if (player.hitTestObject(bed)) {
					l1.bedG.gotoAndStop(2);


					if (spacePressed && !sleeping) {
						if (day == 28) {
							t.ask(["寝て、将来に向かいますか？"], "寝る", "寝ない", 7);
						} else {
							t.ask(["寝て、次の日まで進めますか？"], "寝る", "寝ない", 1);
						}
					}
				} else {
					l1.bedG.gotoAndStop(1);
				}

				if (laptopMode == true) {
					cs.gotoAndStop("laptop");
				} else if (!title && !sleeping && !endingHandler) {
					cs.gotoAndStop("normal");
				}


				//laptop
				if (player.hitTestObject(laptop)) {
					l1.laptopG.gotoAndStop(2);
					if (spacePressed) {
						laptopMode = true;
						paused = true;
					}
				} else {
					l1.laptopG.gotoAndStop(1);
				}
				if (player.hitTestObject(l1.closet.hitbox)) {
					l1.closet.gotoAndStop("open");
					if (spacePressed && !paused) {
						paused = true;
						if (costume == "normal") {
							entering = true;
							trans();
						} else {
							entering = false;
							trans();
						}
					}
					if (transition.currentLabel == "change") {
						if (entering) {
							costume = "panda";
						} else {
							costume = "normal";
						}
					} else if (transition.currentLabel == "done") {
						paused = false;
					}
				} else {
					l1.closet.gotoAndStop("closed");
				}

				//exit
				if (player.hitTestObject(l1.door.hitbox)) {
					if (upPressed) {
						upA = true;
						paused = true;
						entering = true;
						l1.door.play();
						fadeOut(l1);
						wall.gotoAndStop("hallway");
					} else {
						upA = false
					}
				}


			} //end bedroom

			if (currentSpace == 2) { //hallway

				if (player.hitTestObject(l2.door.hitbox)) {
					upA = true;
					downA = true;
					if (upPressed) {
						paused = true;
						entering = true;
						l2.door.play();
						fadeOut(l2);
						wall.gotoAndStop("bathroom");
					}
					if (downPressed) {
						paused = true;
						entering = false;
						fadeIn(l1);
						l1.door.play();
						wall.gotoAndStop("bedroom");
					}
				} else {
					upA = false;
					downA = false;
				}
				if (player.hitTestObject(bed)) {
					sideA = true;
				} else {
					sideA = false;
				}
				if (player.hitTestObject(goDown)) {
					sideA = true;
					entering = true;
					trans();
				} else {
					sideA = false;
				}
				if (transition.currentLabel == "change" && entering) {
					player.x = 325;
					wall.gotoAndStop("downstairs");
					currentSpace = 4;
					gotoAndStop(2);
				}

			} //end hallway
			if (currentSpace == 3) { //bathroom
				if (player.hitTestObject(shower)) {
					player.water.play();
				}
				if (player.hitTestObject(l2.door.hitbox)) {
					downA = true;
					if (downPressed) {
						paused = true;
						entering = false;
						fadeIn(l2);
						l2.door.play();
						wall.gotoAndStop("hallway");
					}
				} else {
					downA = false;
				}

			} //end bathroom
			if (currentSpace == 4) { //downstairs
				sachio.gotoAndStop(sachioC);
				iriC = counter;
				iri.gotoAndStop(iriC);
				if (counter == 11) {
					foodCounter = 6;
					decoration.gotoAndStop(2);
				} else {
					decoration.gotoAndStop(1);
				}
				if (!eaten) {
					food.gotoAndStop(currentFood);
				} else {
					food.gotoAndStop("empty");
				}


				if (player.hitTestObject(goUp)) {
					upArrow.visible = true
					if (upPressed) {
						wall.gotoAndStop("hallway");
						entering = false;
						trans();

					}
				} else {
					upArrow.visible = false
				}

				if (player.hitTestObject(takako) && spacePressed) {
					if (day == 28) {
						t.say(["誕生日おめでとう！！今日はだらだらしていいよ！"]);
					} else if (stamina == 100) {
						t.say(["強すぎる！負けたくないから、やめとく。"]);
					} else if (energy < 50) {
						t.say(["無理しないでね。明日もあるよ！"]);
					} else if (hunger < 30) {
						t.say(["お腹すいてない？食べたら行こう！"]);
					} else {
						t.ask(["いい天気やね！一緒にテニスの練習しない？"], "しよう！", "しない", 5);
						t.info.gotoAndStop(3);
					}
				}
				if (player.hitTestObject(sachioHB) && spacePressed) {
					if (!eaten) {
						if (day == 28) {
							t.ask(["誕生日おめでとう！！ケーキ食べてね！"], "食べる", "食べない", 6);
						} else if (energy < 40) {
							t.say(["眠そう！早く寝たほうがええで！"]);
						} else {
							t.info.gotoAndStop(2);
							switch (foodCounter) {
								case 1:
									t.ask(["今日は寿司やで！食べる？"], "食べる", "食べない", 6);
									break;
								case 2:
									t.ask(["タイカレー！辛くて美味しいよ"], "食べる", "食べない", 6);
									break;
								case 3:
									t.ask(["天丼はいかがでしょうか？"], "食べる", "食べない", 6);
									break;
								case 4:
									t.ask(["ご飯の時間や！今日はカツカレー！"], "食べる", "食べない", 6);
									break;
								case 5:
									t.ask(["今日のメニューは魔峰豆腐です"], "吃", "不吃", 6);
									break;
							}
						}
					}　　
					else {
						t.say(["食べてくれてありがとうね！"]);
					}
				}

				if (transition.currentLabel == "change" && !entering) {
					currentSpace = 2;
					gotoAndStop(1);
					player.x = 1100;
					l1.alpha = 0;
				}

			} //end downstairs





			//UI

			if (!uiOpen) {
				ui.gotoAndStop("normal");
			} else {
				ui.gotoAndStop("expand");
			}

			ui.face.gotoAndStop(costume);
			percentEnergy = energy / max;
			percentHunger = hunger / max;
			percentFun = fun / max;
			percentMaster = master / max;
			ui.energyB.scaleX = percentEnergy;
			ui.energy.text = energy;
			ui.hungerB.scaleX = percentHunger;
			ui.hunger.text = hunger;
			ui.funB.scaleX = percentFun;
			ui.fun.text = fun;
			ui.masterB.scaleX = percentMaster;

			ui.intelligence.text = intelligence;
			ui.stamina.text = stamina;
			ui.culture.text = culture;

			ui.day.text = day;




			//CLothes
			player.gotoAndStop(costume);

			//ASAKO CONTROLS
			if (!paused) {
				if (rightPressed && !rightBumping) {
					player.x += speed;
					player.scaleX = 1;
				}
				if (leftPressed && !leftBumping) {
					player.x -= speed;
					player.scaleX = -1;
				}
			}

			//WALL COLLISION TEST
			if (wall.hitTestPoint(player.x - player.width / 2, player.y - player.height / 2, true)) {
				leftBumping = true;
			} else {
				leftBumping = false;
			}

			if (wall.hitTestPoint(player.x + player.width / 2, player.y - player.height / 2, true)) {
				rightBumping = true;
			} else {
				rightBumping = false;
			}
		}
		function trans(): void {
			transition.play();
		}
		function playTennis(): void {
			var funCount: int = 16 + Math.floor(Math.random() * 9);
			cs.gotoAndStop("tennis");
			staminaDisplay = 5 + Math.floor(Math.random() * 9);
			trace(staminaDisplay);
			cs.stamina.text = staminaDisplay;
			cs.fun.text = funCount;
			cs.court.gotoAndStop(1 + Math.floor(Math.random() * 3));
			if(stamina > 85){
				cs.tennisBG.gotoAndStop(1);
			} else if (stamina > 70){
				cs.tennisBG.gotoAndStop(2);
			} else if (stamina > 60){
				cs.tennisBG.gotoAndStop(3);
			} else if (stamina > 45){
				cs.tennisBG.gotoAndStop(4);
			} else if (stamina > 30){
				cs.tennisBG.gotoAndStop(5);
			} else if (stamina > 15){
				cs.tennisBG.gotoAndStop(6);
			} else {
				cs.tennisBG.gotoAndStop(7);
			}
			stamina += staminaDisplay;
			energy -= 50;
			hunger -= 30;
			fun += funCount;
			paused = true;
			timer = 100;
		}

		function newDay(): void {
			//var
			counter++;
			energy = 100;
			hunger -= 10;
			fun -= 10

			eaten = false;
			paused = true;
			sleeping = true;
			//random events
			var random: int = 1 + Math.floor(Math.random() * 3)
			sachioC = random;

		}
		function doMaster(): void {
			masterDisplay = 6 + intelligence / 10 + Math.floor(Math.random() * 3);
			master += masterDisplay;
			energy -= 30;
			fun -= 10;
			hunger -= 5;
		}
		function doR(): void {
			intelligenceDisplay = 5 + Math.floor(Math.random() * 4);
			intelligence += intelligenceDisplay;
			energy -= 20;
			fun -= 10;
			hunger -= 5;
		}
		function doNetflix(): void {
			funDisplay = 16 + Math.floor(Math.random() * 9);
			fun += funDisplay;
			cultureDisplay = 5 + Math.floor(Math.random() * 5);
			culture += cultureDisplay;
			energy -= 40;
			hunger -= 10;
		}
		function doFood(): void {
			hungerDisplay = 70 + Math.floor(Math.random() * 11);
			hunger += hungerDisplay;
			energy -= 40;
			cs.gotoAndStop("food");
			cs.food.gotoAndStop(currentFood);
			if (foodCounter == 6) {
				cs.t_hunger.text = "";
			} else {
				cs.t_hunger.text = "+" + hungerDisplay + " hunger";
			}
			paused = true;
			timer = 100;
			eaten = true;
			if (foodCounter < 5) {
				foodCounter++;
			} else if (foodCounter == 5) {
				foodCounter = 1;
			}


		}

		function doEnding(): void {
			if (intelligence == 100) {
				ministerEnding = true
				ministerE = true;
			} else if (stamina == 100) {
				staminaEnding = true;
				staminaE = true;
			} else if (culture == 100) {
				cultureEnding = true;
				cultureE = true;
			} else {
				normalEnding = true;
				normalE = true;
			}
			endingHandler = true;
			saveGame();
			cs.gotoAndStop("ending");
			cs.endcs.gotoAndStop("thesis");
			currentEnding = 1;
			if (master < 30) {
				finalGrade = "F"
			} else if (master >= 30 && master < 40) {
				finalGrade = "D-"
			} else if (master >= 40 && master < 50) {
				finalGrade = "D+"
			} else if (master >= 50 && master < 60) {
				finalGrade = "C-"
			} else if (master >= 60 && master < 70) {
				finalGrade = "C+"
			} else if (master >= 70 && master < 80) {
				finalGrade = "B-"
			} else if (master >= 80 && master < 90) {
				finalGrade = "B+"
			} else if (master >= 90 && master < 100) {
				finalGrade = "A"
			} else if (master == 100) {
				finalGrade = "A+"
			}
		}

		function fadeIn(mc: MovieClip): void {
			TweenLite.to(mc, 1, {
				alpha: 1
			});
		}

		function fadeOut(mc: MovieClip): void {
			TweenLite.to(mc, 1, {
				alpha: 0
			});
		}

		//more ui
		function clickUi(e: MouseEvent): void {
			toggleUi();
		}
		function toggleUi(): void {
			if (uiOpen) {
				uiOpen = false;
			} else {
				uiOpen = true;
			}
		}
		function toggleScreen(): void {
			if (fullScreen == false) {
				fullScreen = true;
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			} else {
				fullScreen = false;
				stage.displayState = StageDisplayState.NORMAL;
			}

		}

		public function doYesno(yesnoCase): void {
			switch (yesnoCase) {
				case 0: //default
					trace("gut");
					break;

				case 1: //sleep
					newDay();
					break;
				case 2: // master thesis
					doMaster();
					break;
				case 3: // rstudio
					doR();
					break;
				case 4: // netflix
					doNetflix();
					break;
				case 5: // tennis
					playTennis();
					break;
				case 6: // eat food
					doFood();
					break;
				case 7:
					doEnding();
					break;
			}
		}


		function saveGame(): void {
			trace("saved");
			so.data.en = normalEnding;
			so.data.es = staminaEnding;
			so.data.ec = cultureEnding;
			so.data.em = ministerEnding;
			so.flush();
		}

		function loadGame(): void {
			trace("loaded");
			normalEnding = so.data.en;
			staminaEnding = so.data.es;
			cultureEnding = so.data.ec;
			ministerEnding = so.data.em;
		}


		//KEYHANDLER
		function keyDownHandler(e: KeyboardEvent) {
			switch (e.keyCode) {
				case 32: //space
					spacePressed = true;
					break;

				case 65:
					leftPressed = true;
					break;

				case 37:
					leftPressed = true;
					break;

				case 87:
					upPressed = true;
					break;

				case 38:
					upPressed = true;
					break;

				case 39:
					rightPressed = true;
					break;

				case 68:
					rightPressed = true;
					break;

				case 83:
					downPressed = true;
					break;

				case 40:
					downPressed = true;
					break;
				case 13: //enter
					break;
			}
		}

		function keyUpHandler(e: KeyboardEvent) {
			switch (e.keyCode) {
				case 32: //space
					spacePressed = false;
					break;
				case 65:
					leftPressed = false;
					break;
				case 37:
					leftPressed = false;
					break;
				case 87:
					upPressed = false;
					break;
				case 38:
					upPressed = false;
					break;
				case 39:
					rightPressed = false;
					break;
				case 68:
					rightPressed = false;
					break;
				case 83:
					downPressed = false;
					break;
				case 40:
					downPressed = false;
					break;
				case 73: //I
					toggleUi();
					break;
				case 70: //F
					toggleScreen()
					break;


			}

		} //END KEYS
	}

}