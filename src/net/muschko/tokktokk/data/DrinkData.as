package net.muschko.tokktokk.data
{
    /**
     * Ein Eintrag
     *
     * @author Henning Muschko
     */
    public class DrinkData
    {
        private var _ml:Number;

        private var _date:Date;

        public function DrinkData()
        {
        }

        public function get ml():Number
        {
            return _ml;
        }

        public function set ml(value:Number):void
        {
            _ml = value;
        }

        public function get date():Date
        {
            return _date;
        }

        public function set date(value:Date):void
        {
            _date = value;
        }
    }
}