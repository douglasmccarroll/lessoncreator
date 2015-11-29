package com.brightworks.lessoncreator.model {
   import com.brightworks.lessoncreator.constants.Constants_Language;

   import flash.utils.Dictionary;

   public class VoiceScriptsInfo {
      public static const ROLE_NAME__DEFAULT:String = "Default";

      public var languageInfoList:Dictionary; // Props are Constants_Language ISO_639_3_CODE strings; values are VoiceScriptsLanguageInfo instances

      public function VoiceScriptsInfo() {
      }
   }
}
