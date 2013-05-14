package net.muschko.tokktokk.screens
{
    import com.greensock.TweenMax;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;

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

        private var liter:TextField = new TextField();
        private var literTextFormat:TextFormat = new TextFormat();

        private var buttonOffest:int = 38;

        public function DrinkScreen()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            // Buttons erstellen
            cupIcon.bitmapData = Assets.cupBitmap.bitmapData;
            cupIcon.y = 23;
            cupIcon.x = 68;
            cupIconSprite.addChild(cupIcon);
            cupIconSprite.useHandCursor = true;
            cupIconSprite.buttonMode = true;
            addChild(cupIconSprite);
            cupIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            cupIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            cupIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, drink);

            // Buttons erstellen
            glassIcon.bitmapData = Assets.glassBitmap.bitmapData;
            glassIcon.y = 23;
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
            beverageIcon.y = 23;
            beverageIcon.x = glassIcon.x + buttonOffest;
            beverageIconSprite.addChild(beverageIcon);
            beverageIconSprite.useHandCursor = true;
            beverageIconSprite.buttonMode = true;
            addChild(beverageIconSprite);
            beverageIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
            beverageIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            beverageIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, drink);

            literTextFormat.font = "myFont";
            literTextFormat.size = 11;
            literTextFormat.bold = true;
            literTextFormat.color = 0x666666;
            literTextFormat.align = "center";
            liter.antiAliasType = AntiAliasType.NORMAL;
            liter.y = 30;
            liter.embedFonts = true;
            liter.x = stage.stageWidth - 40;
            liter.defaultTextFormat = literTextFormat;
            liter.selectable = false;
            liter.mouseEnabled = true;
            liter.width = 35;
            liter.height = 20;
            addChild(liter);
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

        override public function over(e:MouseEvent):void
        {
            if (e.currentTarget == cupIconSprite) {
                liter..text = "200ml";
            }
            if (e.currentTarget == glassIconSprite) {
                liter..text = "300ml";
            }
            if (e.currentTarget == beverageIconSprite) {
                liter..text = "500ml";
            }
            TweenMax.to(liter, 0.3, {alpha: 1});
        }

        override public function out(e:MouseEvent):void
        {
            TweenMax.to(liter, 0.3, {alpha: 0});
        }
    }
}