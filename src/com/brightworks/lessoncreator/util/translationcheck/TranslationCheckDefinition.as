package com.brightworks.lessoncreator.util.translationcheck {
   import com.brightworks.lessoncreator.constants.Constants_LineType;

   import flash.utils.Dictionary;

   public class TranslationCheckDefinition {
      public var nativeLanguageIso639_3Code:String;
      public var targetLanguageIso639_3Code:String;
      public var translateFromString:String;
      public var translateToStringList:Array;
      public var translationDirection:String;

      public function TranslationCheckDefinition(
            nativeLanguageIso639_3Code:String,
            targetLanguageIso639_3Code:String,
            translateFromString:String,
            translateToStringList:Array,
            translationDirection:String) {
         this.nativeLanguageIso639_3Code = nativeLanguageIso639_3Code;
         this.targetLanguageIso639_3Code = targetLanguageIso639_3Code;
         this.translateFromString = translateFromString;
         this.translateToStringList = translateToStringList;
         this.translationDirection = translationDirection;
      }

   }
}
