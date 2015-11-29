package com.brightworks.lessoncreator.constants {

   public class Constants_ApplicationState {
      public static const APPLICATION_STATE__PRIMARY__CREATE_PRODUCTION_SCRIPTS:String = "Create Production Scripts";
      public static const APPLICATION_STATE__PRIMARY__LOG_OUTPUT:String = "View Log Output";
      public static const APPLICATION_STATE__PRIMARY__HOME:String = "Home";
      public static const APPLICATION_STATE__PRIMARY__SEARCH:String = "Search";
      public static const APPLICATION_STATE_LIST__PRIMARY_STATES:Array = [  // These are ordered as we wish them to be ordered in the primary view selection dropdown
         APPLICATION_STATE__PRIMARY__HOME,
         APPLICATION_STATE__PRIMARY__CREATE_PRODUCTION_SCRIPTS,
         APPLICATION_STATE__PRIMARY__SEARCH,
         APPLICATION_STATE__PRIMARY__LOG_OUTPUT
         ]
   }
}
