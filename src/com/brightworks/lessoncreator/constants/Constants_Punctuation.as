package com.brightworks.lessoncreator.constants {

   public class Constants_Punctuation {
      public static const COLON__CHINESE:String = "：";
      public static const COLONS:Array = [':', '：'];
      public static const HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO:Object = 
         {
            hanziPunctuation:  ["。", ["，", "、"], "：", "；", "？", "！", "'", ['"', '“', '”'], "《", "》"],
            pinyinPunctuation: [".",  ",",          ":",  ";",  "?",  "!",  "'", ['"', '“', '”'], "《", "》"],
            combinedPunctuation: ["。", "，", "、", "：", "；", "？", "！", ".",  ",", ":",  ";",  "?",  "!",  "'", '"', '“', '”', "《", "》"]
      }
      public static const QUOTATION_MARKS__DOUBLE:Array = ['"', '“', '”'];
   }
}
