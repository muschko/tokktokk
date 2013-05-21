package net.muschko.tokktokk.screens
{
    import air.update.events.StatusUpdateEvent;

    import avmplus.getQualifiedClassName;

    import com.greensock.TweenMax;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.net.registerClassAlias;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.utils.getDefinitionByName;

    import net.muschko.tokktokk.assets.Assets;
    import net.muschko.tokktokk.common.Settings;
    import net.muschko.tokktokk.data.DrinkData;
    import net.muschko.tokktokk.data.UserData;
    import net.muschko.tokktokk.native.UpdateTokkTokk;

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

        private var buttonOffset:int = 38;
        private var buttonOffsetTop:int = 23;

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
        private var toolbarBackground:Bitmap = new Bitmap();
        private var toolbarBackgroundSprite:Sprite = new Sprite();

        // TokkTokk Logo
        private var tokktokk:Bitmap = new Bitmap();


        // Aktueller Screen
        private var currentScreen:Sprite;

        // Signalton
        private var signal:Sound = Assets.signalSound as Sound;

        // Updater
        private var updateTokkTokk:UpdateTokkTokk = new UpdateTokkTokk(true);
        private var updateInfo:UpdateScreen = new UpdateScreen();

        public function MainScreen()
        {
            super();
            registerClassAlias("UserData", UserData);
            this.addEventListener(Event.ADDED_TO_STAGE, initializeHandler);
            this.addEventListener("UPDATE_LITER", updateLiter);
        }

        private function initializeHandler(e:Event):void
        {
            addChild(updateInfo);
            updateInfo.visible = false;

            // Toolbar Hintergrund
            toolbarBackground.bitmapData = Assets.backgroundBitmap.bitmapData;
            toolbarBackgroundSprite.addChild(toolbarBackground);
            toolbarBackgroundSprite.y = 15;
            toolbarBackgroundSprite.x = 10;
            toolbarBackgroundSprite.addEventListener(MouseEvent.MOUSE_DOWN, moveToolbar);
            toolbarBackgroundSprite.addEventListener(MouseEvent.MOUSE_UP, saveToolbarPosition);
            addChild(toolbarBackgroundSprite);

            tokktokk.bitmapData = Assets.tokktokkBitmap.bitmapData;
            tokktokk.x = 7;
            tokktokk.y = 6;
            addChild(tokktokk);

            // Buttons erstellen
            playIcon.y = buttonOffsetTop;
            playIcon.x = 68;
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
            consumptionFormat.size = 13;
            consumptionFormat.bold = true;
            consumptionFormat.color = 0x666666;
            consumptionFormat.align = "center";
            consumptionTextField.antiAliasType = AntiAliasType.NORMAL;
            consumptionTextField.y = 28;
            consumptionTextField.embedFonts = true;
            consumptionTextField.x = stage.stageWidth - 31;
            consumptionTextField.defaultTextFormat = consumptionFormat;
            consumptionTextField.selectable = false;
            consumptionTextField.mouseEnabled = true;
            consumptionTextField.width = 35;
            consumptionTextField.height = 20;
            addChild(consumptionTextField);
            //consumptionTextField.addEventListener(MouseEvent.CLICK, changeHUD);

            userData = UserData.getUserData();

            // Setzt die Timer
            setTimer();

            // Anzeige aktualisieren
            this.dispatchEvent(new Event("UPDATE_LITER"));

            // Überprüft ob ein update vorliegt
            updateTokkTokk.update();
            updateTokkTokk.updaterUI.addEventListener(StatusUpdateEvent.UPDATE_STATUS, check);
        }

        /**
         * Setzt die Timer
         */
        public function setTimer():void
        {
            // Wenn reminding angeschaltet ist
            if (userData._remind) {
                startTimer();
                playIcon.bitmapData = Assets.pauseBitmap.bitmapData;
            }
            else {
                killTimer();
                playIcon.bitmapData = Assets.okBitmap.bitmapData;
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
            // Wenn reminding angeschaltet ist
            if (userData._remind) {
                killTimer();
                startTimer();
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
                consumptionTextField.text = (consumption / 1000) + " l";
            }

            if (consumption >= userData._dailyRequirement && !requiredConsumptionComplete) {

                var color:uint = 0x98be01;
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
                consumptionTextField.text = (consumption / 1000) + " l";
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

            killTimer();

            openRemindScreen();
        }

        /**
         * Öffnet den Reminderscreen
         */
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
         *
         * @param screenName
         * @param params
         */
        private function createScreen(screenName:Class, params:Object = null):void
        {

            TweenMax.to(tokktokk, 0.3, {alpha: 0 });
            var screen:Class = getDefinitionByName(getQualifiedClassName(screenName)) as Class;
            if (params != null) {
                currentScreen = new screen(params);
            } else {
                currentScreen = new screen();
            }
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
            userData = UserData.getUserData();

            // Wenn reminding angeschaltet ist
            if (userData._remind) {
                userData._remind = false;
                killTimer();
                playIcon.bitmapData = Assets.okBitmap.bitmapData;
                UserData.saveUserData(userData);
            }
            else {
                userData._remind = true;
                startTimer();
                playIcon.bitmapData = Assets.pauseBitmap.bitmapData;
                UserData.saveUserData(userData);
            }
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
            TweenMax.to(tokktokk, 0.3, {alpha: 1 });
            TweenMax.to(currentScreen, 0.3, {alpha: 0, onComplete: function ():void
            {
                updateLiter(null);
                removeChild(currentScreen);
            }});
        }

        /**
         * Update Check und Anzeige bei einem Update
         * @param event
         */
        private function check(event:StatusUpdateEvent):void
        {
            if (event.available) {
                updateInfo.visible = true;
                updateInfo.showUpdateInfo(event.version);
            }
        }

        /**
         * Kill Timer
         */
        private function killTimer():void
        {
            if (remindTimer != null) {
                remindTimer.reset();
                remindTimer.removeEventListener(TimerEvent.TIMER, remind);
                remindTimer = null;
            }
        }

        /**
         * Start Timer
         */
        private function startTimer():void
        {
            //  Userdaten
            userData = UserData.getUserData();
            timerMilliseconds = (userData._remindTime * 60 * 1000);

            remindTimer = new Timer(timerMilliseconds);
            remindTimer.start();
            remindTimer.addEventListener(TimerEvent.TIMER, remind);
        }
    }
}
