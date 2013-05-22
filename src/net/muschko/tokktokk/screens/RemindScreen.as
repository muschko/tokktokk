package net.muschko.tokktokk.screens
{

    import com.greensock.TweenMax;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.net.registerClassAlias;
    import flash.system.Capabilities;
    import flash.ui.Keyboard;
    import flash.ui.Mouse;
    import flash.utils.Timer;

    import net.muschko.tokktokk.data.UserData;

    /**
     * Erinngerungs-Screen
     *
     * @author Henning Muschko
     */
    public class RemindScreen extends Sprite
    {
        // Hintergrund
        public var background:Sprite = new Sprite();

        // Timer
        private var timer:Timer = new Timer(12000, 1);

        public function RemindScreen()
        {
            super();
            registerClassAlias("UserData", UserData);
            this.addEventListener(Event.ADDED_TO_STAGE, initializeHandler);
        }

        private function initializeHandler(e:Event):void
        {
            Mouse.hide();
            stage.addEventListener(KeyboardEvent.KEY_DOWN, bossEscapeScreen);

            // Bildschirm aktivieren und vergrößern
            addChild(background);
            background.graphics.clear();
            background.graphics.beginFill(0x000000);
            background.graphics.drawRect(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
            background.graphics.endFill();
            background.alpha = 0;

            TweenMax.to(background, 5, {alpha: 0.7});

            timer.start();
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, closeScreen);
        }

        /**
         * Schließt den ReminderScreen
         * @param event
         */
        private function closeScreen(event:Event):void
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, closeScreen);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, bossEscapeScreen);
            this.dispatchEvent(new Event("QUIT_REMIND"));
        }

        /**
         * Schließt den ReminderScrenn mit "ESC"
         * @param event
         */
        private function bossEscapeScreen(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ESCAPE) {
                Mouse.show();
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, closeScreen);
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, bossEscapeScreen);
                this.dispatchEvent(new Event("BOSS_QUIT_REMIND"));
            }
        }
    }
}