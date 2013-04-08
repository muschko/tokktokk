package net.muschko.tokktokk.native
{
    import flash.desktop.DockIcon;
    import flash.desktop.NativeApplication;
    import flash.desktop.SystemTrayIcon;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.InvokeEvent;
    import flash.events.MouseEvent;
    import flash.events.ScreenMouseEvent;
    import flash.net.URLRequest;

    import net.muschko.tokktokk.common.Settings;

    public class SystemTray
    {
        // Loader für Icon
        private var icon:Loader = new Loader();

        // Context Menus
        private var contextMenues:ContextMenues;

        public function SystemTray(contextMenues:ContextMenues)
        {
            this.contextMenues = contextMenues;
            setSystemTrayMenu();
        }

        public function setSystemTrayMenu():void
        {
            // Setzt die Icons für Minimierung
            NativeApplication.nativeApplication.autoExit = false;

            // System Tray für Windows
            if (NativeApplication.supportsSystemTrayIcon) {
                NativeApplication.nativeApplication.autoExit = false;
                icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete);
                icon.load(new URLRequest("icons/TokkTokk16.png"));

                var systray:SystemTrayIcon =
                        NativeApplication.nativeApplication.icon as SystemTrayIcon;
                systray.tooltip = "TokkTokk!";
                systray.addEventListener(MouseEvent.CLICK, activate);
                systray.menu = contextMenues.trayMenu;
            }

            // System Tray für Mac OS
            if (NativeApplication.supportsDockIcon) {
                icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete);
                icon.load(new URLRequest("icons/TokkTokk128.png"));
                var dock:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
                dock.addEventListener(ScreenMouseEvent.CLICK, activate);
                NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, activate);
                dock.menu = contextMenues.trayMenu;
            }
        }

        /**
         * Oncomplete Loader für das Icon
         * @param event
         */
        private function iconLoadComplete(event:Event):void
        {
            NativeApplication.nativeApplication.icon.bitmaps = [event.target.content.bitmapData];
        }

        private function activate(event:Event):void
        {
            Settings.nativeWindow.activate();
            Settings.nativeWindow.visible = true;
        }
    }
}