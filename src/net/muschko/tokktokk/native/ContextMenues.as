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

    public class ContextMenues
    {
        // Tray Kontextmenu
        public var trayMenu:NativeMenu = new NativeMenu();

        // RightClick Menu
        public var rightClickMenu:NativeMenu = new NativeMenu();

        // Updater
        private var updater:UpdateTokkTokk = new UpdateTokkTokk(true);

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

            // Title Kontext
            var titleItem:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("TokkTokk! " + version));
            titleItem.enabled = false;

            var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
            trayMenu.addItem(separatorA);

            // Update Kontext
            var updateCommand:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("Nach Updates suchen..."));
            updateCommand.addEventListener(Event.SELECT, update);

            // Über Kontext
            var aboutCommand:NativeMenuItem = trayMenu.addItem(new NativeMenuItem("Über TokkTokk!"));
            aboutCommand.addEventListener(Event.SELECT, openLink);

            // Schließen Menu nur bei Windows anzeigen
            if (Capabilities.os.search("Windows") >= 0) {

                var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
                trayMenu.addItem(separatorA);

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

            // Title Kontext
            var titleItem:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("TokkTokk! " + version));
            titleItem.enabled = false;

            var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
            rightClickMenu.addItem(separatorA);

            // Über Kontext
            var updateCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Nach Updates suchen..."));
            updateCommand.addEventListener(Event.SELECT, update);

            // Update Kontext
            var aboutCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Über TokkTokk!"));
            aboutCommand.addEventListener(Event.SELECT, openLink);

            var separatorA:NativeMenuItem = new NativeMenuItem("A", true);
            rightClickMenu.addItem(separatorA);

            var exitCommand:NativeMenuItem = rightClickMenu.addItem(new NativeMenuItem("Schließen"));
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
    }
}
