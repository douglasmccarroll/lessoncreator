package com.brightworks.lessoncreator.constants {
import com.brightworks.util.Log;
import com.brightworks.util.Utils_DataConversionComparison;

   public class Constants_Language {
      public static const DISPLAY_NAME__CMN:String = "Mandarin Chinese";
      public static const DISPLAY_NAME__ENG:String = "English";
      public static const ISO_639_3_CODE__CMN:String = "cmn";
      public static const ISO_639_3_CODE__ENG:String = "eng";
      public static const LANGUAGE_CODE_LIST:Array = [
         ISO_639_3_CODE__CMN,
         ISO_639_3_CODE__ENG];

      public function Constants_Language() {
      }

      public static function getDisplayNameForIso639_3Code(code:String):String {
         var result:String;
         switch (code) {
            case ISO_639_3_CODE__CMN:
               result = DISPLAY_NAME__CMN;
               break;
            case ISO_639_3_CODE__ENG:
               result = DISPLAY_NAME__ENG;
               break;
            default:
               Log.error("LanguageInfo.getDisplayNameForIso639_3Code(): No match for code: " + code);
         }
         return result;
      }

      public static function getLanguageCodeListString():String {
         return Utils_DataConversionComparison.convertArrayToDelimitedString(LANGUAGE_CODE_LIST, ", ");
      }

      public static function isStringLanguageCode(s:String):Boolean {
         return (LANGUAGE_CODE_LIST.indexOf(s) > -1);
      }
   }
}

