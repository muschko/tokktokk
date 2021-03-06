package net.muschko.tokktokk.native
{
    import flash.desktop.DockIcon;
    import flash.desktop.NativeApplication;
    import flash.desktop.SystemTrayIcon;
    import flash.events.Event;
    import flash.events.InvokeEvent;
    import flash.events.MouseEvent;
    import flash.events.ScreenMouseEvent;

    import net.muschko.tokktokk.assets.Assets;
    import net.muschko.tokktokk.common.Settings;

    public class SystemTray
    {
        // Context Menus
        private var contextMenues:ContextMenues;

        // Windows Systray
        private var systray:SystemTrayIcon;

        // MacOS Dock
        private var dock:DockIcon

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
                NativeApplication.nativeApplication.icon.bitmaps = [Assets.trayBitmap];

                systray = NativeApplication.nativeApplication.icon as SystemTrayIcon;
                systray.tooltip = "tokk!tokk!";
                systray.addEventListener(MouseEvent.CLICK, activate);
                systray.menu = contextMenues.trayMenu;
            }

            // Dock Icon für Mac OS
            if (NativeApplication.supportsDockIcon) {
                NativeApplication.nativeApplication.icon.bitmaps = [Assets.dockBitmap];

                dock = NativeApplication.nativeApplication.icon as DockIcon;
                dock.addEventListener(ScreenMouseEvent.CLICK, activate);
                dock.addEventListener(ScreenMouseEvent.RIGHT_CLICK, activate);
                dock.menu = contextMenues.trayMenu;
                NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, activate);
            }
        }

        private function activate(event:Event):void
        {
            Settings.nativeWindow.activate();
            Settings.nativeWindow.alwaysInFront = true;
            Settings.nativeWindow.alwaysInFront = false;
        }
    }
}