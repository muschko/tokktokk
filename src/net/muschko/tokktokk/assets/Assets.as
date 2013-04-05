package net.muschko.tokktokk.assets
{
    import flash.display.Bitmap;
    import flash.media.Sound;

    public class Assets
    {

        [Embed(source="../../../../../media/assets/images/ok.png")]
        private static const OkBitmap:Class;
        public static const okBitmap:Bitmap = new OkBitmap();

        [Embed(source="../../../../../media/assets/images/info.png")]
        private static const InfoBitmap:Class;
        public static const infoBitmap:Bitmap = new InfoBitmap();

        [Embed(source="../../../../../media/assets/images/drop_icon.png")]
        private static const DropBitmap:Class;
        public static const dropBitmap:Bitmap = new DropBitmap();

        [Embed(source="../../../../../media/assets/images/clock.png")]
        private static const ClockBitmap:Class;
        public static const clockBitmap:Bitmap = new ClockBitmap();

        [Embed(source="../../../../../media/assets/images/settings.png")]
        private static const SettingsBitmap:Class;
        public static const settingsBitmap:Bitmap = new SettingsBitmap();

        [Embed(source="../../../../../media/assets/images/close_white.png")]
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

        [Embed(source="../../../../../media/assets/images/clock_half.png")]
        private static const ClockHalfBitmap:Class;
        public static const clockHalfBitmap:Bitmap = new ClockHalfBitmap();

        [Embed(source="../../../../../media/assets/images/clock_full.png")]
        private static const ClockFullBitmap:Class;
        public static const clockFullBitmap:Bitmap = new ClockFullBitmap();

        [Embed(source="../../../../../media/assets/images/sound_on.png")]
        private static const SoundOnBitmap:Class;
        public static const soundOnBitmap:Bitmap = new SoundOnBitmap();

        [Embed(source="../../../../../media/assets/images/sound_off.png")]
        private static const SoundOffBitmap:Class;
        public static const soundOffBitmap:Bitmap = new SoundOffBitmap();

        [Embed(source="../../../../../media/assets/images/exit.png")]
        private static const ExitBitmap:Class;
        public static const exitBitmap:Bitmap = new ExitBitmap();

        [Embed(source="../../../../../media/assets/fonts/Helvetica.ttf",
                fontName="myFont",
                mimeType="application/x-font",
                fontWeight="normal",
                fontStyle="normal",
                advancedAntiAliasing="true",
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
