package net.muschko.tokktokk.native
{
    import air.update.ApplicationUpdaterUI;
    import air.update.events.DownloadErrorEvent;
    import air.update.events.StatusUpdateErrorEvent;
    import air.update.events.StatusUpdateEvent;
    import air.update.events.UpdateEvent;

    import flash.events.ErrorEvent;

    public class UpdateTokkTokk
    {
        // Update Config
        private var updateURL:String = "http://www.tokktokk.de/update.xml";

        // Upater
        private var updater:ApplicationUpdaterUI = new ApplicationUpdaterUI();

        public function UpdateTokkTokk()
        {
            updater.updateURL = updateURL;
            updater.delay = 1;
            updater.addEventListener(ErrorEvent.ERROR, error);
            updater.addEventListener(UpdateEvent.INITIALIZED, init);
            updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, check);
            updater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, checkError);
            updater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, downloadError);
        }

        public function update():void
        {
            updater.initialize();
        }

        private function error(event:ErrorEvent):void
        {
            trace("ERROR " + event.errorID);
        }

        private function init(event:UpdateEvent):void
        {
            trace("INIT");
            updater.checkNow();
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
    }
}
