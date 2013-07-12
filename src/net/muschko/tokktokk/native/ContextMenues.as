package net.muschko.tokktokk.native
{
    import flash.desktop.NativeApplication;
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.system.Capabilities;

    import net.muschko.tokktokk.common.Settings;
    import net.muschko.tokktokk.data.UserData;

    public class ContextMenues
    {
        // Tray Kontextmenu
        public var trayMenu:NativeMenu = new NativeMenu();

        // RightClick Menu
        public var rightClickMenu:NativeMenu = new NativeMenu();

        // Updater
        private var updater:UpdateTokkTokk = new UpdateTokkTokk(false);

        // UserData
        private var userData:UserData;

        public function ContextMenues()
        {
            setTrayMenu();
            setRightClickMenu();
        }

        /**
         * Tray-Menu belegen
         */
        private function setTrayMenu():void
        {
            var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = xml.namespace();
            var version:String = xml.ns::versionNumber;

            userData = UserData.getUserData();

            // Title Kontext
            var titleItem:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("tokk!tokk! " + version));
            titleItem.enabled = false;

            var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
            trayMenu.addItem(separatorA);

            // Update Kontext
            var updateCommand:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("Nach Updates suchen..."));
            updateCommand.addEventListener(Event.SELECT, update);

            // Minimiert bleiben
            /*var stayMinimizedCommand:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("Minimiert bleiben"));
             stayMinimizedCommand.checked = userData._minimized;
             stayMinimizedCommand.addEventListener(Event.SELECT, stayMinimized);*/

            // Über Kontext
            var aboutCommand:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("Über tokk!tokk!"));
            aboutCommand.addEventListener(Event.SELECT, openLink);

            // Schließen Menu nur bei Windows anzeigen
            if (Capabilities.os.search("Windows") >= 0) {

                var separatorC:NativeMenuItem = new NativeMenuItem("A", true);
                trayMenu.addItem(separatorC);

                var exitCommand:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("Schließen"));
                exitCommand.addEventListener(Event.SELECT, function (event:Event):void
                {
                    NativeApplication.nativeApplication.icon.bitmaps = [];
                    NativeApplication.nativeApplication.exit();
                });
            }
        }

        /**
         * Right-Click-Menu belegen
         */
        private function setRightClickMenu():void
        {
            var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = xml.namespace();
            var version:String = xml.ns::versionNumber;

            userData = UserData.getUserData();

            // Title Kontext
            var titleItem:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("tokk!tokk! " + version));
            titleItem.enabled = false;

            var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
            rightClickMenu.addItem(separatorA);

            // Über Kontext
            var updateCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Nach Updates suchen..."));
            updateCommand.addEventListener(Event.SELECT, update);

            // Einstellungen zurücksetzen
            var resetCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Einstellungen zurücksetzen"));
            resetCommand.addEventListener(Event.SELECT, reset);

            // Minimiert bleiben
            /*var stayMinimizedCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Minimiert bleiben"));
             stayMinimizedCommand.checked = userData._minimized;
             stayMinimizedCommand.addEventListener(Event.SELECT, stayMinimized);*/

            // Update Kontext
            var aboutCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Über tokk!tokk!"));
            aboutCommand.addEventListener(Event.SELECT, openLink);

            var separatorB:NativeMenuItem = new NativeMenuItem("A", true);
            rightClickMenu.addItem(separatorB);

            var exitCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Minimieren"));
            exitCommand.addEventListener(Event.SELECT, function (event:Event):void
            {
                event.preventDefault();
                Settings.nativeWindow.visible = false;
            });
        }

        /**
         * Updated die Anwendung
         * @param event
         */
        private function stayMinimized(event:Event):void
        {
            var userData:UserData = UserData.getUserData();

            if (userData._minimized) {
                userData._minimized = false;
                UserData.saveUserData(userData);
                Settings.nativeWindow.visible = true;
                Settings.nativeWindow.orderToFront();
                new SystemTray(new ContextMenues());

            } else {
                userData._minimized = true;
                UserData.saveUserData(userData);
                Settings.nativeWindow.visible = false;
                new SystemTray(new ContextMenues());
            }
        }

        /**
         * Minimiert bleiben
         * @param event
         */
        private function update(event:Event):void
        {
            updater.update();
        }

        /**
         * TokkTokk! Link öffnen
         * @param event
         */
        private function openLink(event:Event):void
        {
            var targetURL:URLRequest = new URLRequest("http://www.tokktokk.de");
            navigateToURL(targetURL, "_blank");
        }

        /**
         * Setzt die Einstellungen zurück
         * @param event
         */
        private function reset(event:Event):void
        {
            UserData.saveUserData(new UserData());
            NativeApplication.nativeApplication.exit();
        }
    }
}
