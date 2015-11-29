package com.brightworks.lessoncreator.util.contentrestriction {

   public class ContentRestriction {

      public static const SURROUNDING_CONTENT_TYPE__ANY:String = "SURROUNDING_CONTENT_TYPE__ANY";
      public static const SURROUNDING_CONTENT_TYPE__WHITE_SPACE_AND_PUNCTUATION:String = "SURROUNDING_CONTENT_TYPE__WHITE_SPACE_AND_PUNCTUATION";

      //public var humanReadableFixDescription:String;
      public var caseSensitive:Boolean;
      public var restrictedContent:String;
      public var followedBy:String;
      public var precededBy:String;

   }
}
