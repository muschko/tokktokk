package net.muschko.tokktokk.screens
{

    import com.greensock.TweenMax;
    import com.greensock.easing.Expo;

    import flash.display.GradientType;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import net.muschko.tokktokk.native.UpdateTokkTokk;

    /**
     * Update-Screen
     *
     * @author Henning Muschko
     */
    public class UpdateScreen extends Sprite
    {
        // TextFeld
        private var labelUpdateTextField:TextField = new TextField();
        private var labelFormat:TextFormat = new TextFormat();

        // Hintergrund
        public var background:Sprite = new Sprite();

        // Timer
        private var updater:UpdateTokkTokk = new UpdateTokkTokk(false);

        // Version
        public var version:String;

        public function UpdateScreen()
        {
            this.version = version;
            this.addEventListener(Event.ADDED_TO_STAGE, initializeHandler);
        }

        private function initializeHandler(e:Event):void
        {
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(163, 24, (Math.PI / 180) * 90, 0, 00);
            //background.graphics.lineStyle(1, 0x627a00);
            background.graphics.beginGradientFill(GradientType.LINEAR, [0x98be01, 0x8daf08], [1, 1], [0, 255], matrix);
            background.graphics.drawRoundRect(0, 0, 130, 30, 10, 10);
            background.graphics.endFill();
            background.y = 30;
            background.x = 50;
            addChild(background);

            labelFormat.font = "myFont";
            labelFormat.size = 11;
            labelFormat.bold = false;
            labelFormat.color = 0xffffff;
            // labelFormat.color = 0x42742c;

            labelUpdateTextField.antiAliasType = AntiAliasType.NORMAL;
            labelUpdateTextField.y = 41;
            labelUpdateTextField.x = 60;
            labelUpdateTextField.autoSize = TextFieldAutoSize.LEFT;
            labelUpdateTextField.embedFonts = true;
            labelUpdateTextField.selectable = false;
            labelUpdateTextField.mouseEnabled = true;
            labelUpdateTextField.defaultTextFormat = labelFormat;
            addChild(labelUpdateTextField);

            this.addEventListener(MouseEvent.CLICK, update);
            this.mouseEnabled = true;
            this.useHandCursor = true;
            this.buttonMode = true;
        }

        /**
         * Zeigt die VersionsInfo
         * @param version
         */
        public function showUpdateInfo(version:String):void
        {
            labelUpdateTextField.text = "Update verfügbar: " + version;

            TweenMax.to(this, 0.5, {y: 20, ease: Expo.easeOut, delay: 2});
            TweenMax.to(this, 0.5, {y: 0, alpha: 0, ease: Expo.easeOut, delay: 7});
        }

        private function update(event:MouseEvent):void
        {
            updater.update();
        }
    }
}