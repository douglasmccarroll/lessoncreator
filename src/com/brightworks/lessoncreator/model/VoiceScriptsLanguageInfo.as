package com.brightworks.lessoncreator.model {
   import com.brightworks.lessoncreator.constants.Constants_Language;

   import flash.utils.Dictionary;

   public class VoiceScriptsLanguageInfo {
      public var languageCode:String; // Holds a Constants_Language ISO_639_3_CODE string
      public var roleInfoList:Dictionary; // Props are role name strings; values are VoiceScriptsRoleInfo instances

      public function VoiceScriptsLanguageInfo() {
      }
   }
}
