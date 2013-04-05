package net.muschko.tokktokk.screens
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import net.muschko.tokktokk.assets.Assets;
    import net.muschko.tokktokk.data.DrinkData;
    import net.muschko.tokktokk.data.UserData;

    /**
     * Standardscreen
     *
     * @author Henning Muschko
     */
    public class DrinkScreen extends CommonScreen
    {
        // Buttons
        private var cupIcon:Bitmap = new Bitmap();
        private var cupIconSprite:Sprite = new Sprite();

        private var glassIcon:Bitmap = new Bitmap();
        private var glassIconSprite:Sprite = new Sprite();

        private var beverageIcon:Bitmap = new Bitmap();
        private var beverageIconSprite:Sprite = new Sprite();

        private var buttonOffest:int = 40;

        public function DrinkScreen()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            // Buttons erstellen
            cupIcon.bitmapData = Assets.cupBitmap.bitmapData;
            cupIcon.y = 8;
            cupIcon.x = 15;
            cupIconSprite.addChild(cupIcon);
            cupIconSprite.useHandCursor = true;
            cupIconSprite.buttonMode = true;
            addChild(cupIconSprite);
            cupIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            cupIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            cupIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, drink);

            // Buttons erstellen
            glassIcon.bitmapData = Assets.glassBitmap.bitmapData;
            glassIcon.y = 7;
            glassIcon.x = cupIcon.x + buttonOffest;
            glassIconSprite.addChild(glassIcon);
            glassIconSprite.useHandCursor = true;
            glassIconSprite.buttonMode = true;
            addChild(glassIconSprite);
            glassIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            glassIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            glassIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, drink);

            // Buttons erstellen
            beverageIcon.bitmapData = Assets.beverageBitmap.bitmapData;
            beverageIcon.y = 8;
            beverageIcon.x = glassIcon.x + buttonOffest;
            beverageIconSprite.addChild(beverageIcon);
            beverageIconSprite.useHandCursor = true;
            beverageIconSprite.buttonMode = true;
            addChild(beverageIconSprite);
            beverageIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            beverageIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            beverageIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, drink);
        }

        private function drink(event:MouseEvent):void
        {
            var drinkData:DrinkData = new DrinkData();
            drinkData.date = new Date();

            if (event.currentTarget == cupIconSprite) {
                drinkData.ml = 200;
            }
            if (event.currentTarget == glassIconSprite) {
                drinkData.ml = 300;
            }
            if (event.currentTarget == beverageIconSprite) {
                drinkData.ml = 500;
            }

            userData._history.push(drinkData);
            UserData.saveUserData(userData);

            this.quitScreen(null);
        }
    }
}