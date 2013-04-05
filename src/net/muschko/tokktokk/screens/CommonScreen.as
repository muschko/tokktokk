package net.muschko.tokktokk.screens
{
    import com.greensock.TweenMax;

    import flash.display.Bitmap;
    import flash.display.GradientType;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import net.muschko.tokktokk.assets.Assets;
    import net.muschko.tokktokk.common.Settings;
    import net.muschko.tokktokk.data.UserData;

    /**
     * Standardscreen
     *
     * @author Henning Muschko
     */
    public class CommonScreen extends Sprite
    {
        // Hintergrund
        private var background:Sprite = new Sprite();

        // Buttons
        private var closeIcon:Bitmap = new Bitmap();
        private var closeIconSprite:Sprite = new Sprite();

        // Userdaten
        public var userData:UserData = UserData.getUserData();

        public function CommonScreen()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            addChild(background);
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(163, 24, (Math.PI / 180) * 90, 0, 00);
            background.graphics.lineStyle(1, 0x333333);
            background.graphics.beginGradientFill(GradientType.LINEAR, [0x555555, 0x333333], [1, 1], [0, 255], matrix);
            background.graphics.drawRoundRect(0, 0, 229, 50, 10, 10);
            background.graphics.endFill();
            background.alpha = 0;
            background.addEventListener(MouseEvent.MOUSE_DOWN, moveToolbar);
            background.addEventListener(MouseEvent.MOUSE_UP, saveToolbarPosition);

            addChild(closeIconSprite);
            closeIcon.bitmapData = Assets.closeBitmap.bitmapData;
            closeIcon.y = 9;
            closeIcon.x = stage.stageWidth - closeIcon.width - 10;
            closeIconSprite.addChild(closeIcon);
            closeIconSprite.useHandCursor = true;
            closeIconSprite.buttonMode = true;
            closeIconSprite.addEventListener(MouseEvent.CLICK, quitScreen);
            closeIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            closeIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);


            TweenMax.to(background, 0.3, {alpha: 1, onComplete: function ():void
            {
            }});
        }

        /**
         * Schließt den Screen
         * @param event
         */
        public function quitScreen(event:MouseEvent):void
        {
            this.dispatchEvent(new Event("QUIT_SCREEN"));
        }

        /**
         * Over Mouse Event
         * @param event
         */
        public function over(event:MouseEvent):void
        {
            TweenMax.to(event.currentTarget, 0.3, {alpha: 0.5});
        }

        /**
         * Over Mouse Event
         * @param event
         */
        public function out(event:MouseEvent):void
        {
            TweenMax.to(event.currentTarget, 0.5, {alpha: 1});
        }

        /**
         * Bewegt die Toolbar
         *
         * @param event
         */
        private function moveToolbar(event:MouseEvent):void
        {
            Settings.nativeWindow.alwaysInFront = true;
            Settings.nativeWindow.startMove();
        }

        /**
         * Speichert die FensterPosition
         * @param event
         */
        private function saveToolbarPosition(event:MouseEvent):void
        {
            userData._windowPosition = new Point(Settings.nativeWindow.x, Settings.nativeWindow.y);
            UserData.saveUserData(userData);
        }
    }
}