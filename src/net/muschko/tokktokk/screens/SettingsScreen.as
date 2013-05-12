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
        private var inputBackground:Bitmap = new Bitmap();

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
            inputFormat.size = 17;
            inputFormat.bold = true;
            inputFormat.color = 0x333333;
            inputFormat.align = "center";

            labelFormat.font = "myFont";
            labelFormat.size = 18;
            labelFormat.bold = true;
            labelFormat.color = 0x666666;

            // Toolbar Hintergrund
            inputBackground.bitmapData = Assets.backgroundInputBitmap.bitmapData;
            inputBackground.x = 57;
            inputBackground.y = 12;
            addChild(inputBackground);

            inputMinutesTextField.antiAliasType = AntiAliasType.NORMAL;
            inputMinutesTextField.y = 11;
            inputMinutesTextField.x = 58;
            inputMinutesTextField.embedFonts = true;
            inputMinutesTextField.defaultTextFormat = inputFormat;
            inputMinutesTextField.selectable = true;
            inputMinutesTextField.type = TextFieldType.INPUT;
            inputMinutesTextField.width = 30;
            inputMinutesTextField.height = 30;
            inputMinutesTextField.text = userData._remindTime.toString();
            inputMinutesTextField.restrict = "0-9";
            inputMinutesTextField.maxChars = 2;
            addChild(inputMinutesTextField);

            labelMinutesTextField.antiAliasType = AntiAliasType.NORMAL;
            labelMinutesTextField.y = 10;
            labelMinutesTextField.x = 90;
            labelMinutesTextField.autoSize = TextFieldAutoSize.LEFT;
            labelMinutesTextField.embedFonts = true;
            labelMinutesTextField.selectable = false;
            labelMinutesTextField.defaultTextFormat = labelFormat;
            labelMinutesTextField.text = "Minuten";
            addChild(labelMinutesTextField);

            // Buttons erstellen
            soundOnIcon.bitmapData = Assets.soundOnBitmap.bitmapData;
            soundOnIcon.y = 9;
            soundOnIcon.x = stage.stageWidth - soundOnIcon.width - 10;
            soundOnIconSprite.addChild(soundOnIcon);
            soundOnIconSprite.useHandCursor = true;
            soundOnIconSprite.buttonMode = true;
            addChild(soundOnIconSprite);
            soundOnIconSprite.addEventListener(MouseEvent.MOUSE_DOWN, setSound);

            if (!userData._remindSignal) {
                soundOnIcon.bitmapData = Assets.soundOffBitmap.bitmapData;
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
                soundOnIcon.bitmapData = Assets.soundOffBitmap.bitmapData;
            } else {
                userData._remindSignal = true;
                soundOnIcon.bitmapData = Assets.soundOnBitmap.bitmapData;
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
    }
}