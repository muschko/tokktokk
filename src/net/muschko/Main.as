package net.muschko
{
    import flash.desktop.NativeApplication;
    import flash.display.NativeWindow;
    import flash.display.NativeWindowDisplayState;
    import flash.display.Screen;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NativeWindowDisplayStateEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.registerClassAlias;

    import net.muschko.tokktokk.AppController;
    import net.muschko.tokktokk.common.Settings;
    import net.muschko.tokktokk.data.DrinkData;
    import net.muschko.tokktokk.data.UserData;
    import net.muschko.tokktokk.native.ContextMenues;
    import net.muschko.tokktokk.native.SystemTray;

    /**
     * TokkTokk! Desktop-Anwendung
     *
     * @author Henning Muschko
     */
    [SWF(width='230', height='50', backgroundColor='#000000', frameRate='30')]
    public class Main extends Sprite
    {
        // Appcontroller
        private var appController:AppController = new AppController();

        // Userdaten
        private var userData:UserData;

        // SystemTray
        private var systemTray:SystemTray;

        // ContextMenues
        private var contextMenues:ContextMenues = new ContextMenues();

        public function Main():void
        {
            registerClassAlias("UserData", UserData);
            registerClassAlias("DrinkData", DrinkData);
            registerClassAlias("Point", Point);

            if (stage) {
                init();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }

        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            // Neues UserObjekt erstellen, falls es noch nicht existiert
            if (UserData.getUserData() == null) {
                UserData.saveUserData(new UserData());
            }

            userData = UserData.getUserData();

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.DEACTIVATE, deactivate);
            stage.addEventListener(Event.ACTIVATE, activate);

            // Settings
            var appBounds:Rectangle = stage.nativeWindow.bounds;
            var screen:Screen = Screen.getScreensForRectangle(appBounds)[0];

            // Gespeicherte Einstellungen setzen
            Settings.visibleBounds = screen.bounds;
            Settings.stageWidth = stage.stageWidth;
            Settings.stageHeight = stage.stageHeight;
            Settings.nativeWindow = (NativeApplication.nativeApplication.openedWindows[0] as NativeWindow);
            Settings.nativeWindow.x = userData._windowPosition.x;
            Settings.nativeWindow.y = userData._windowPosition.y;

            // SystemTray setztn
            systemTray = new SystemTray(contextMenues);

            // Prüft ab ob
            stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, displayStateChangeEventHandler);
            Settings.nativeWindow.addEventListener(Event.CLOSING, closingWindow);
            stage.addEventListener(MouseEvent.RIGHT_CLICK, rightClickMenu);

            // Fügt die Anwendung hinzu
            addChild(appController);
        }


        /**
         * Auf minimieren prüfen
         * @param event
         */
        private function displayStateChangeEventHandler(event:NativeWindowDisplayStateEvent):void
        {
            switch (stage.nativeWindow.displayState) {
                case NativeWindowDisplayState.MINIMIZED:
                    userData._minimized = true;
                    UserData.saveUserData(userData);
                    break;
            }
        }

        /**
         * Deaktivierung
         * @param event
         */
        private function deactivate(event:Event):void
        {
            stage.frameRate = 1;
            appController.visible = false;
        }

        /**
         * Aktivierung
         * @param event
         */
        private function activate(event:Event):void
        {
            stage.frameRate = 30;
            appController.visible = true;
        }

        /**
         * Rechtsklick Menü
         * @param event
         */
        private function rightClickMenu(event:MouseEvent):void
        {
            contextMenues.rightClickMenu.display(stage, mouseX, mouseY);
        }

        /**
         * Verhindert das Schließen über die Taskleiste
         * @param event
         */
        private function closingWindow(event:Event):void
        {
            // Nur bei Windows unsichtbar schalten beim Schließen
            if (NativeApplication.supportsSystemTrayIcon) {
                event.preventDefault();
                Settings.nativeWindow.visible = false;
            }

        }
    }
}