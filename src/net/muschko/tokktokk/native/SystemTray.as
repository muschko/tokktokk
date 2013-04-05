package net.muschko.tokktokk.native
{
    import flash.desktop.DockIcon;
    import flash.desktop.NativeApplication;
    import flash.desktop.SystemTrayIcon;
    import flash.display.Loader;
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.system.Capabilities;

    public class SystemTray
    {
        // Loader für Icon
        private var icon:Loader = new Loader();

        // Kontextmenu
        private var contextMenu:NativeMenu = new NativeMenu();

        // Updater
        private var updater:UpdateTokkTokk = new UpdateTokkTokk();

        public function SystemTray()
        {
        }

        public function setSystemTray():void
        {
            // Setzt die Icons für Minimierung
            NativeApplication.nativeApplication.autoExit = false;

            // Setzt das Kontextmenu
            setContextMenu();

            // System Tray für Windows
            if (NativeApplication.supportsSystemTrayIcon) {
                NativeApplication.nativeApplication.autoExit = false;
                icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete);
                icon.load(new URLRequest("icons/TokkTokk16.png"));

                var systray:SystemTrayIcon =
                        NativeApplication.nativeApplication.icon as SystemTrayIcon;
                systray.tooltip = "TokkTokk!";
                systray.menu = contextMenu;
            }

            // System Tray für Mac OS
            if (NativeApplication.supportsDockIcon) {
                icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete);
                icon.load(new URLRequest("icons/TokkTokk128.png"));
                var dock:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
                dock.menu = contextMenu;
            }
        }

        /**
         * Kontextmenu belegen
         */
        private function setContextMenu():void
        {
            // Über Kontext
            var aboutCommand:NativeMenuItem = contextMenu.addItem(new NativeMenuItem("Über TokkTokk!"));
            aboutCommand.addEventListener(Event.SELECT, openLink);

            // Über Kontext
            var updateCommand:NativeMenuItem = contextMenu.addItem(new NativeMenuItem("Nach Updates suchen"));
            updateCommand.addEventListener(Event.SELECT, update);

            // Schließen Menu nur bei Windows anzeigen
            if (Capabilities.os.search("Windows") >= 0) {

                var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
                contextMenu.addItem(separatorA);

                var exitCommand:NativeMenuItem = contextMenu.addItem(new NativeMenuItem("Schließen"));
                exitCommand.addEventListener(Event.SELECT, function (event:Event):void
                {
                    NativeApplication.nativeApplication.icon.bitmaps = [];
                    NativeApplication.nativeApplication.exit();
                });
            }
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
         * Oncomplete Loader für das Icon
         * @param event
         */
        private function iconLoadComplete(event:Event):void
        {
            NativeApplication.nativeApplication.icon.bitmaps = [event.target.content.bitmapData];
        }

        /**
         * Updated die Anwendung
         * @param event
         */
        private function update(event:Event):void
        {
            updater.update();
        }
    }
}
