package net.muschko.tokktokk.screens
{
    import avmplus.getQualifiedClassName;

    import com.greensock.TweenMax;

    import flash.display.Bitmap;
    import flash.display.GradientType;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.net.registerClassAlias;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.utils.getDefinitionByName;

    import net.muschko.tokktokk.assets.Assets;
    import net.muschko.tokktokk.common.Settings;
    import net.muschko.tokktokk.data.DrinkData;
    import net.muschko.tokktokk.data.UserData;

    /**
     * Main-Toolbar
     *
     * @author Henning Muschko
     */
    public class MainScreen extends Sprite
    {
        // Buttons
        private var dropIcon:Bitmap = new Bitmap();
        private var dropIconSprite:Sprite = new Sprite();

        private var settingsIcon:Bitmap = new Bitmap();
        private var settingsIconSprite:Sprite = new Sprite();

        private var playIcon:Bitmap = new Bitmap();
        private var playIconSprite:Sprite = new Sprite();

        private var minimizeIcon:Bitmap = new Bitmap();
        private var minimizeIconSprite:Sprite = new Sprite();

        private var exitIcon:Bitmap = new Bitmap();
        private var exitIconSprite:Sprite = new Sprite();

        private var buttonOffset:int = 40;
        private var buttonOffsetTop:int = 10;

        // Textfelder
        private var consumptionTextField:TextField = new TextField();
        private var consumptionFormat:TextFormat = new TextFormat();
        private var consumption:Number = 0;
        private var showPercent:Boolean = false;

        // Flags
        private var requiredConsumptionComplete:Boolean = false;

        // UserData
        private var userData:UserData;

        // Timer
        private var remindTimer:Timer;
        private var timerMilliseconds:Number;

        // Toolbar Background
        private var toolbarBackground:Sprite = new Sprite();

        // Aktueller Screen
        private var currentScreen:CommonScreen;

        // Signalton
        private var signal:Sound = Assets.signalSound as Sound;

        public function MainScreen()
        {
            super();
            registerClassAlias("UserData", UserData);
            this.addEventListener(Event.ADDED_TO_STAGE, initializeHandler);
            this.addEventListener("UPDATE_LITER", updateLiter);
        }

        private function initializeHandler(e:Event):void
        {
            // Toolbar Hintergrund
            addChild(toolbarBackground);
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(163, 24, (Math.PI / 180) * 90, 0, 00);
            toolbarBackground.graphics.lineStyle(1, 0xDDDDDD);
            toolbarBackground.graphics.beginGradientFill(GradientType.LINEAR, [0xfafafa, 0xEFEFEF], [1, 1], [0, 255], matrix);
            toolbarBackground.graphics.drawRoundRect(0, 0, 229, 49, 10, 10);
            toolbarBackground.graphics.endFill();
            toolbarBackground.y = 0;
            toolbarBackground.addEventListener(MouseEvent.MOUSE_DOWN, moveToolbar);
            toolbarBackground.addEventListener(MouseEvent.MOUSE_UP, saveToolbarPosition);

            // Buttons erstellen
            playIcon.bitmapData = Assets.okBitmap.bitmapData;
            playIcon.y = buttonOffsetTop;
            playIcon.x = 10;
            playIconSprite.addChild(playIcon);
            playIconSprite.useHandCursor = true;
            playIconSprite.buttonMode = true;
            playIconSprite.addEventListener(MouseEvent.CLICK, toggleRemind);
            addChild(playIconSprite);

            settingsIcon.bitmapData = Assets.clockBitmap.bitmapData;
            settingsIcon.y = buttonOffsetTop;
            settingsIcon.x = playIcon.x + buttonOffset;
            settingsIconSprite.addChild(settingsIcon);
            settingsIconSprite.useHandCursor = true;
            settingsIconSprite.buttonMode = true;
            settingsIconSprite.addEventListener(MouseEvent.CLICK, openToolTip);
            addChild(settingsIconSprite);

            dropIcon.bitmapData = Assets.dropBitmap.bitmapData;
            dropIcon.y = buttonOffsetTop;
            dropIcon.x = settingsIcon.x + buttonOffset;
            dropIconSprite.addChild(dropIcon);
            dropIconSprite.useHandCursor = true;
            dropIconSprite.buttonMode = true;
            dropIconSprite.addEventListener(MouseEvent.CLICK, openToolTip);
            addChild(dropIconSprite);

            consumptionFormat.font = "myFont";
            consumptionFormat.size = 20;
            consumptionFormat.bold = false;
            consumptionFormat.color = 0x666666;
            consumptionTextField.antiAliasType = AntiAliasType.NORMAL;
            consumptionTextField.y = buttonOffsetTop;
            consumptionTextField.embedFonts = true;
            consumptionTextField.x = stage.stageWidth - consumptionTextField.width - 15;
            consumptionTextField.defaultTextFormat = consumptionFormat;
            consumptionTextField.autoSize = TextFieldAutoSize.RIGHT;
            consumptionTextField.selectable = false;
            consumptionTextField.mouseEnabled = true;
            addChild(consumptionTextField);
            consumptionTextField.addEventListener(MouseEvent.CLICK, changeHUD);

            //  Userdaten
            userData = UserData.getUserData();

            timerMilliseconds = (userData._remindTime * 60 * 1000);
            //remindTimer = new Timer(timerMilliseconds);
            remindTimer = new Timer(5000);

            // Setzt die Timer
            setTimer();

            // Anzeige aktualisieren
            this.dispatchEvent(new Event("UPDATE_LITER"));
        }

        /**
         * Setzt die Timer
         */
        public function setTimer():void
        {
            // Wenn reminding angeschaltet ist
            if (userData._remind) {
                remindTimer.start();
                remindTimer.addEventListener(TimerEvent.TIMER, remind);

                playIconSprite.alpha = 1;
            }
            else {
                playIconSprite.alpha = 0.5;
            }

            toolbarBackground.addEventListener(MouseEvent.MOUSE_DOWN, moveToolbar);
            toolbarBackground.addEventListener(MouseEvent.MOUSE_UP, saveToolbarPosition);
        }

        /**
         * Updated die Zeit der Erinnerung
         * @param event
         */
        private function updateTime(event:Event):void
        {
            userData = UserData.getUserData();
            timerMilliseconds = userData._remindTime * 60 * 1000;

            // Wenn reminding angeschaltet ist
            if (userData._remind) {
                remindTimer.stop();
                remindTimer = new Timer(timerMilliseconds);
                remindTimer.start();
                remindTimer.addEventListener(TimerEvent.TIMER, remind);
            }
        }

        /**
         * Checkt ob der Alarm ausgelöst werden muss
         * @param e
         */
        private function updateLiter(e:Event):void
        {
            // Aktuelle Userdaten holen
            userData = UserData.getUserData();

            // Anzeige zurücksetzen
            consumption = 0;

            // Heutige Trinkanzeige
            var today:Date = new Date();
            for (var i:int = 0; i < userData._history.length; i++) {
                var drinkData:DrinkData = userData._history[i];
                if (today.getDate() == drinkData.date.getDate() && today.getDay() == drinkData.date.getDay() && today.getFullYear() == drinkData.date.getFullYear()) {
                    consumption += drinkData.ml;
                }
            }

            if (showPercent) {
                consumptionTextField.text = Math.round(( 100 / userData._dailyRequirement) * consumption) + "%";
            } else {
                consumptionTextField.text = (consumption / 1000) + " liter";
            }

            if (consumption >= userData._dailyRequirement && !requiredConsumptionComplete) {

                var color:uint = 0x3D873A;
                TweenMax.to(consumptionTextField, 1, {tint: color});
                requiredConsumptionComplete = true;
            }
        }

        /**
         * Schaltet die Trinkanzeige um
         * @param event
         */
        private function changeHUD(event:Event):void
        {
            if (!showPercent) {
                consumptionTextField.text = Math.round(( 100 / userData._dailyRequirement) * consumption) + "%";
                showPercent = true;
            } else {
                consumptionTextField.text = (consumption / 1000) + " liter";
                showPercent = false;
            }
        }

        /**
         * Checkt ob der Alarm ausgelöst werden muss
         * @param e
         */
        private function remind(e:TimerEvent):void
        {
            if (Settings.nativeWindow.startMove()) {
                toolbarBackground.removeEventListener(MouseEvent.MOUSE_DOWN, moveToolbar);
                toolbarBackground.removeEventListener(MouseEvent.MOUSE_UP, saveToolbarPosition);
            }

            remindTimer.stop();
            remindTimer.removeEventListener(TimerEvent.TIMER, remind);

            openRemindScreen();
        }

        private function openRemindScreen():void
        {
            if (userData._remindSignal) {
                signal.play();
            }

            // Position des Fensters merken
            Settings.nativWindowPositionX = Settings.nativeWindow.x;
            Settings.nativWindowPositionY = Settings.nativeWindow.y;

            this.dispatchEvent(new Event("REMIND"));
        }

        /**
         * Erstellt das Tooltip
         * @param screenName
         */
        private function createScreen(screenName:Class):void
        {
            var screen:Class = getDefinitionByName(getQualifiedClassName(screenName)) as Class;
            currentScreen = new screen();
            currentScreen.addEventListener("QUIT_SCREEN", quitScreen);
            currentScreen.addEventListener("UPDATE_LITER", updateLiter);
            currentScreen.addEventListener("UPDATE_TIME", updateTime);
            addChild(currentScreen);
        }

        /**
         * Öffnet eine Subtoolbar
         * @param event
         */
        private function openToolTip(event:MouseEvent):void
        {
            if (event.currentTarget == dropIconSprite) {
                createScreen(DrinkScreen);
            } else if (event.currentTarget == settingsIconSprite) {
                createScreen(SettingsScreen);
            }
        }

        /**
         * Toggled den Reminder
         * @param event
         */
        private function toggleRemind(event:MouseEvent):void
        {
            // Wenn reminding angeschaltet ist
            if (userData._remind) {
                userData._remind = false;
                playIconSprite.alpha = 0.5;

                remindTimer.stop();
                remindTimer.removeEventListener(TimerEvent.TIMER, remind);
            }
            else {
                userData._remind = true;
                playIconSprite.alpha = 1;
                remindTimer.start();
                remindTimer.addEventListener(TimerEvent.TIMER, remind);
            }
            UserData.saveUserData(userData);
        }

        /**
         * Bewegt die Toolbar
         * @param event
         */
        private function moveToolbar(event:MouseEvent):void
        {
            Settings.nativeWindow.alwaysInFront = true;
            Settings.nativeWindow.orderToFront();
            Settings.nativeWindow.startMove();
        }

        /**
         * Speichert die FensterPosition
         * @param event
         */
        private function saveToolbarPosition(event:MouseEvent):void
        {
            Settings.nativeWindow.alwaysInFront = false;
            userData._windowPosition = new Point(Settings.nativeWindow.x, Settings.nativeWindow.y);
            UserData.saveUserData(userData);
        }

        /**
         * Schließt den Sub-Screen
         * @param event
         */
        private function quitScreen(event:Event):void
        {
            TweenMax.to(currentScreen, 0.3, {alpha: 0, onComplete: function ():void
            {
                updateLiter(null);
                removeChild(currentScreen);
            }});

        }
    }
}
