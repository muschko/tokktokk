package net.muschko.tokktokk.screens
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;

    import net.muschko.tokktokk.assets.Assets;
    import net.muschko.tokktokk.data.UserData;

    /**
     * Settings
     *
     * @author Henning Muschko
     */
    public class SettingsScreen extends CommonScreen
    {
        private var inputMinutesTextField:TextField = new TextField();
        private var labelMinutesTextField:TextField = new TextField();
        private var inputFormat:TextFormat = new TextFormat();
        private var labelFormat:TextFormat = new TextFormat();

        private var soundOnIcon:Bitmap = new Bitmap();
        private var soundOnIconSprite:Sprite = new Sprite();

        private var buttonOffest:int = 40;

        public function SettingsScreen()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            // Eingabe erstellen
            inputFormat.font = "myFont";
            inputFormat.size = 20;
            inputFormat.bold = false;
            inputFormat.color = 0xffffff;
            inputFormat.align = "center";

            labelFormat.font = "myFont";
            labelFormat.size = 18;
            labelFormat.bold = false;
            labelFormat.color = 0xFFFFFF;

            inputMinutesTextField.antiAliasType = AntiAliasType.NORMAL;
            inputMinutesTextField.y = 10;
            inputMinutesTextField.x = 10;
            inputMinutesTextField.embedFonts = true;
            inputMinutesTextField.defaultTextFormat = inputFormat;
            inputMinutesTextField.selectable = true;
            inputMinutesTextField.type = TextFieldType.INPUT;
            inputMinutesTextField.width = 30;
            inputMinutesTextField.height = 30;
            inputMinutesTextField.text = userData._remindTime.toString();
            inputMinutesTextField.restrict = "0-9";
            inputMinutesTextField.maxChars = 2;
            inputMinutesTextField.addEventListener(Event.CHANGE, inputChange);
            addChild(inputMinutesTextField);

            labelMinutesTextField.antiAliasType = AntiAliasType.NORMAL;
            labelMinutesTextField.y = 12;
            labelMinutesTextField.x = 42;
            labelMinutesTextField.autoSize = TextFieldAutoSize.LEFT;
            labelMinutesTextField.embedFonts = true;
            labelMinutesTextField.selectable = false;
            labelMinutesTextField.defaultTextFormat = labelFormat;
            labelMinutesTextField.text = "Minuten";
            addChild(labelMinutesTextField);

            // Buttons erstellen
            soundOnIcon.bitmapData = Assets.soundOnBitmap.bitmapData;
            soundOnIcon.y = 10;
            soundOnIcon.x = 150;
            soundOnIconSprite.addChild(soundOnIcon);
            soundOnIconSprite.useHandCursor = true;
            soundOnIconSprite.buttonMode = true;
            addChild(soundOnIconSprite);
            soundOnIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, setSound);

            if (!userData._remindSignal) {
                soundOnIconSprite.alpha = 0.5;
                soundOnIcon.bitmapData = Assets.soundOffBitmap.bitmapData;
            } else {
                soundOnIconSprite.alpha = 1;
                soundOnIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
                soundOnIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            }
        }

        /**
         * Toggled den Sound
         * @param event
         */
        private function setSound(event:MouseEvent):void
        {
            if (userData._remindSignal) {
                userData._remindSignal = false;
                soundOnIconSprite.alpha = 0.5;
                soundOnIcon.bitmapData = Assets.soundOffBitmap.bitmapData;
                soundOnIconSprite.removeEventListener(MouseEvent.MOUSE_OVER, over);
                soundOnIconSprite.removeEventListener(MouseEvent.MOUSE_OUT, out);
            } else {
                userData._remindSignal = true;
                soundOnIconSprite.alpha = 1;
                soundOnIcon.bitmapData = Assets.soundOnBitmap.bitmapData;
                soundOnIconSprite.addEventListener(MouseEvent.MOUSE_OVER, over);
                soundOnIconSprite.addEventListener(MouseEvent.MOUSE_OUT, out);
            }
            UserData.saveUserData(userData);
        }

        /**
         * Schließt den Screen
         * @param event
         */
        override public function quitScreen(event:MouseEvent):void
        {
            userData._remindTime = Number(inputMinutesTextField.text);
            UserData.saveUserData(userData);

            this.dispatchEvent(new Event("UPDATE_TIME"));
            this.dispatchEvent(new Event("QUIT_SCREEN"));
        }

        private function inputChange(event:Event):void
        {
            if (inputMinutesTextField.text == "1" || inputMinutesTextField.text == "01") {
                labelMinutesTextField.text = "Minute";
            } else {
                labelMinutesTextField.text = "Minuten";
            }
        }
    }
}