package net.muschko.tokktokk.common
{
    /**
     * Vector Utils
     *
     * @author Henning Muschko
     */
    public class VectorUtil
    {
        /**
         * Konvertiert einen Vektor in ein Array
         *
         * @param    vector:*    vector to be converted
         * @return    Array        converted array
         */
        public static function vectorToArray(vector:*):Array
        {
            var n:int = vector.length;
            var a:Array = new Array();
            for (var i:int = 0; i < n; i++) a[i] = vector[i];
            return a;
        }

        /**
         * Converts vector to an array and sorts it by a certain fieldName, options
         * for more info @see Array.sortOn
         *
         * @param    vector:*            the source vector
         * @param    fieldName:Object    a string that identifies a field to be used as the sort value
         * @param    options:Object        one or more numbers or names of defined constants
         */
        public static function sortOn(vector:*, fieldName:Object, options:Object = null):Array
        {
            return vectorToArray(vector).sortOn(fieldName, options);
        }
    }

}