package net.muschko.tokktokk.assets
{
    import flash.display.Bitmap;
    import flash.media.Sound;

    public class Assets
    {
        [Embed(source="../../../../../media/assets/images/background.png")]
        private static const BackgroundBitmap:Class;
        public static const backgroundBitmap:Bitmap = new BackgroundBitmap();

        [Embed(source="../../../../../media/assets/images/background_sub.png")]
        private static const BackgroundSubBitmap:Class;
        public static const backgroundSubBitmap:Bitmap = new BackgroundSubBitmap();

        /*[Embed(source="../../../../../media/assets/images/background_input.png")]
         private static const BackgroundInputBitmap:Class;
         public static const backgroundInputBitmap:Bitmap = new BackgroundInputBitmap();*/

        [Embed(source="../../../../../media/assets/images/tokktokk.png")]
        private static const TokkTokkBitmap:Class;
        public static const tokktokkBitmap:Bitmap = new TokkTokkBitmap();

        [Embed(source="../../../../../media/assets/images/pause.png")]
        private static const PauseBitmap:Class;
        public static const pauseBitmap:Bitmap = new PauseBitmap();

        [Embed(source="../../../../../media/assets/images/ok.png")]
        private static const OkBitmap:Class;
        public static const okBitmap:Bitmap = new OkBitmap();

        [Embed(source="../../../../../media/assets/images/drop_icon.png")]
        private static const DropBitmap:Class;
        public static const dropBitmap:Bitmap = new DropBitmap();

        [Embed(source="../../../../../media/assets/images/clock.png")]
        private static const ClockBitmap:Class;
        public static const clockBitmap:Bitmap = new ClockBitmap();

        [Embed(source="../../../../../media/assets/images/close.png")]
        private static const CloseBitmap:Class;
        public static const closeBitmap:Bitmap = new CloseBitmap();

        [Embed(source="../../../../../media/assets/images/cup.png")]
        private static const CupBitmap:Class;
        public static const cupBitmap:Bitmap = new CupBitmap();

        [Embed(source="../../../../../media/assets/images/glas.png")]
        private static const GlassBitmap:Class;
        public static const glassBitmap:Bitmap = new GlassBitmap();

        [Embed(source="../../../../../media/assets/images/beverage.png")]
        private static const BeverageBitmap:Class;
        public static const beverageBitmap:Bitmap = new BeverageBitmap();

        [Embed(source="../../../../../media/assets/images/sound_on.png")]
        private static const SoundOnBitmap:Class;
        public static const soundOnBitmap:Bitmap = new SoundOnBitmap();

        [Embed(source="../../../../../media/assets/images/sound_off.png")]
        private static const SoundOffBitmap:Class;
        public static const soundOffBitmap:Bitmap = new SoundOffBitmap();

        [Embed(source="../../../../../media/assets/icons/TokkTokk16.png")]
        private static const TrayBitmap:Class;
        public static const trayBitmap:Bitmap = new TrayBitmap();

        [Embed(source="../../../../../media/assets/icons/TokkTokk128.png")]
        private static const DockcBitmap:Class;
        public static const dockBitmap:Bitmap = new DockcBitmap();

        [Embed(source="../../../../../media/assets/fonts/Helvetica.ttf",
                fontName="myFont",
                mimeType="application/x-font",
                embedAsCFF="false")]
        private var myEmbeddedFont:Class;

        [Embed(source="../../../../../media/assets/sound/sound.mp3")]
        private static const SignalSound:Class;
        public static const signalSound:Sound = new SignalSound();

        public function Assets()
        {
        }
    }
}
