package net.muschko.tokktokk
{
    import com.greensock.TweenMax;

    import flash.desktop.NativeApplication;
    import flash.display.NativeWindowDisplayState;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.system.Capabilities;
    import flash.ui.Mouse;
    import flash.utils.Timer;

    import net.muschko.tokktokk.common.Settings;
    import net.muschko.tokktokk.data.UserData;
    import net.muschko.tokktokk.screens.MainScreen;
    import net.muschko.tokktokk.screens.RemindScreen;

    /**
     * Der AppController zu dem DrinkReminder
     *
     * @author Henning Muschko
     */
    public class AppController extends Sprite
    {
        // Screens
        private var mainToolbar:MainScreen = new MainScreen();
        private var remindScreen:RemindScreen;

        // Hacktimer
        private var timer:Timer = new Timer(500, 1);

        // Userdaten
        private var userData:UserData;

        public function AppController()
        {
            init();
        }

        private function init():void
        {
            this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            addChild(mainToolbar);
            mainToolbar.addEventListener("REMIND", remind);

            //  Userdaten
            userData = UserData.getUserData();


        }

        private function addedToStageHandler(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

            if (userData._minimized) {
                trace("test");
                e.preventDefault();
                Settings.nativeWindow.visible = false;
            }
        }

        /**
         * Öffnet den Reminder-Screen
         * @param event
         */
        private function remind(event:Event):void
        {
            // Blendet die Toolbar aus
            if (Settings.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED) {
                mainToolbar.alpha = 0;
                Settings.nativeWindow.restore();
                timer.start();
                timer.addEventListener(TimerEvent.TIMER, showRemind);
            } else {
                TweenMax.to(mainToolbar, 0.5, {alpha: 0, onComplete: showRemind, onCompleteParams: [null]});
            }
        }

        /**
         * Zeigt den Reminderscreen
         * @param event
         */
        private function showRemind(event:TimerEvent):void
        {
            // WICHTIG! Bringt das Fenster nach ganz vorn
            NativeApplication.nativeApplication.activate(Settings.nativeWindow);

            /* if (Capabilities.os.search("Mac") >= 0) {
             stage.fullScreenSourceRect = new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
             }

             stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

             */
            Settings.nativeWindow.activate();
            Settings.nativeWindow.alwaysInFront = true;
            Settings.nativeWindow.x = 0;
            Settings.nativeWindow.y = 0;
            Settings.nativeWindow.width = Capabilities.screenResolutionX;
            Settings.nativeWindow.height = Capabilities.screenResolutionY;

            // Erstellt den Reminderscreen
            remindScreen = new RemindScreen();
            addChild(remindScreen);
            remindScreen.addEventListener("QUIT_REMIND", quitRemind);
            remindScreen.addEventListener("BOSS_QUIT_REMIND", bossQuitRemind);

        }

        /**
         * Schließt den Reminder-Screen
         * @param event
         */
        private function quitRemind(event:Event):void
        {
            TweenMax.to(remindScreen, 5, {alpha: 0, onComplete: function ():void
            {
                Mouse.show();
                Settings.nativeWindow.alwaysInFront = false;

                // Entfernt den Reminderscreen
                removeChild(remindScreen);

                // Setzt das Fesnter wieder an seine Position zurück
                Settings.nativeWindow.x = Settings.nativWindowPositionX;
                Settings.nativeWindow.y = Settings.nativWindowPositionY;
                Settings.nativeWindow.width = 210;
                Settings.nativeWindow.height = 50;

                TweenMax.to(mainToolbar, 1, {alpha: 1});
                mainToolbar.setTimer();
            }})
        }

        /**
         * Escape Quit
         * @param event
         */
        private function bossQuitRemind(event:Event):void
        {
            // Entfernt den Reminderscreen
            removeChild(remindScreen);

            // Setzt das Fesnter wieder an seine Position zurück
            Settings.nativeWindow.x = Settings.nativWindowPositionX;
            Settings.nativeWindow.y = Settings.nativWindowPositionY;
            Settings.nativeWindow.width = 230;
            Settings.nativeWindow.height = 50;

            TweenMax.to(mainToolbar, 1, {alpha: 1});
            mainToolbar.setTimer();
        }
    }
}