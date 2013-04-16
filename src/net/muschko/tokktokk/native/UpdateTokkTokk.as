package net.muschko.tokktokk.native
{
    import air.update.ApplicationUpdaterUI;
    import air.update.events.DownloadErrorEvent;
    import air.update.events.StatusUpdateErrorEvent;
    import air.update.events.StatusUpdateEvent;
    import air.update.events.UpdateEvent;

    import flash.events.ErrorEvent;
    import flash.events.EventDispatcher;

    public class UpdateTokkTokk extends EventDispatcher
    {
        // Update Config
        private var updateURL:String = "http://www.tokktokk.de/update.xml";

        // Updater UI
        private var _updaterUI:ApplicationUpdaterUI = new ApplicationUpdaterUI();

        public function UpdateTokkTokk(showUI:Boolean)
        {
            _updaterUI.updateURL = updateURL;
            _updaterUI.delay = 1;

            if (!showUI) {
                _updaterUI.isCheckForUpdateVisible = false;
                _updaterUI.isFileUpdateVisible = false;
                _updaterUI.isDownloadProgressVisible = false;
                _updaterUI.isDownloadUpdateVisible = false;
                _updaterUI.isInstallUpdateVisible = false;
                _updaterUI.isUnexpectedErrorVisible = false;
            } else {
                _updaterUI.isCheckForUpdateVisible = false;
            }
            _updaterUI.addEventListener(ErrorEvent.ERROR, error);
            _updaterUI.addEventListener(UpdateEvent.INITIALIZED, init);
            _updaterUI.addEventListener(StatusUpdateEvent.UPDATE_STATUS, check);
            _updaterUI.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, checkError);
            _updaterUI.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, downloadError);
        }

        public function update():void
        {
            _updaterUI.initialize();
        }

        private function error(event:ErrorEvent):void
        {
            trace("ERROR " + event.errorID);
        }

        private function init(event:UpdateEvent):void
        {
            trace("INIT");
            _updaterUI.checkNow();
        }

        private function check(event:StatusUpdateEvent):void
        {
            trace("CHECK" + event.available + " " + event.version);
        }

        private function checkError(event:StatusUpdateErrorEvent):void
        {
            trace("ERROR");
        }

        private function downloadError(event:DownloadErrorEvent):void
        {
            trace("ERROR: " + event.subErrorID);
        }

        public function get updaterUI():ApplicationUpdaterUI
        {
            return _updaterUI;
        }

        public function set updaterUI(value:ApplicationUpdaterUI):void
        {
            _updaterUI = value;
        }
    }
}
