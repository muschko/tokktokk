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
        // Toolbar Background
        private var toolbarBackground:Bitmap = new Bitmap();
        private var toolbarBackgroundSprite:Sprite = new Sprite();

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

            // Toolbar Hintergrund
            toolbarBackground.bitmapData = Assets.backgroundSubBitmap.bitmapData;
            toolbarBackgroundSprite.addChild(toolbarBackground);
            toolbarBackgroundSprite.addEventListener(MouseEvent.MOUSE_DOWN, moveToolbar);
            toolbarBackgroundSprite.addEventListener(MouseEvent.MOUSE_UP, saveToolbarPosition);
            toolbarBackgroundSprite.alpha = 0;
            addChild(toolbarBackgroundSprite);

            addChild(closeIconSprite);
            closeIcon.bitmapData = Assets.closeBitmap.bitmapData;
            closeIcon.y = 9;
            closeIcon.x = 10;
            closeIconSprite.addChild(closeIcon);
            closeIconSprite.useHandCursor = true;
            closeIconSprite.buttonMode = true;
            closeIconSprite.addEventListener(MouseEvent.CLICK, quitScreen);
            //closeIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            //closeIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);

            TweenMax.to(toolbarBackgroundSprite, 0.3, {alpha: 1, onComplete: function ():void
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