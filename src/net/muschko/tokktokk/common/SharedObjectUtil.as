package net.muschko.tokktokk.common
{
    import flash.net.SharedObject;

    /**
     * SharedObject Utils
     *
     * @author Henning Muschko
     */
    public class SharedObjectUtil
    {
        /**
         * Holt ein Object aus dem SharedObject, ist es nicht vorhanden, gibt null zurück
         *
         *    @param    shardObject        SharedObject
         *     @param    propertyName    String
         */
        public static function getProperty(sharedObject:SharedObject, propertyName:String):Object
        {
            if (sharedObject.data[propertyName] == null) {
                return null;
            } else {
                return sharedObject.data[propertyName];
            }
        }

        /**
         * Testet ob das Data Object in dem SharedObject leer ist
         *
         *    @param    shardObject        SharedObject
         */
        public static function isEmpty(sharedObject:SharedObject):Boolean
        {
            if (sharedObject.size == 0) {
                return true;
            } else {
                return false;
            }
        }
    }
}