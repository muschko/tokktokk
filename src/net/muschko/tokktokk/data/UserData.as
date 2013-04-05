package net.muschko.tokktokk.data
{
    import flash.geom.Point;
    import flash.net.SharedObject;
    import flash.net.registerClassAlias;
    import flash.system.Capabilities;

    import net.muschko.tokktokk.common.SharedObjectUtil;

    /**
     * User Daten die gespeichert werden
     *
     * @author Henning Muschko
     */
    public class UserData
    {
        private static const SHARED_OBJECT:String = "TokkTokk";

        public var _remind:Boolean = false;

        public var _remindSignal:Boolean = false;

        public var _remindTime:Number = 30;

        public var _minimized:Boolean = false;

        public var _dailyRequirement:Number = 1500;

        public var _history:Vector.<DrinkData> = new Vector.<DrinkData>();

        public var _windowPosition:Point = new Point(Capabilities.screenResolutionX / 2 - 150, Capabilities.screenResolutionY / 2);

        public function UserData()
        {
            registerClassAlias("UserData", UserData);
            registerClassAlias("DrinkData", DrinkData);
            registerClassAlias("Point", Point);
        }

        public static function getUserData():UserData
        {
            // Shared Object laden
            var sharedObject:SharedObject = SharedObject.getLocal(SHARED_OBJECT);

            return SharedObjectUtil.getProperty(sharedObject, "userData") as UserData;
        }

        public static function saveUserData(userDataProperties:UserData):void
        {
            // Shared Object laden
            var sharedObject:SharedObject = SharedObject.getLocal(SHARED_OBJECT);

            // Speichern des UserObjekts
            sharedObject.setProperty('userData', userDataProperties);
            sharedObject.flush();
            sharedObject.close();
        }

    }

}