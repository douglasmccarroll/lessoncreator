package com.brightworks.lessoncreator.util.translationcheck {
   import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk_Default;
import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.model.MainModel;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_DataConversionComparison;

   import flash.utils.Dictionary;

   public class TranslationCheckProcessor {
      private static const _TRANSLATION_DIRECTION__XML_NODE_NAME__NATIVE_TO_TARGET:String = "nativeToTarget";
      private static const _TRANSLATION_DIRECTION__XML_NODE_NAME__NATIVE_TO_TARGET_PHONETIC:String = "nativeToTargetPhonetic";
      private static const _TRANSLATION_DIRECTION__XML_NODE_NAME__TARGET_TO_NATIVE:String = "targetToNative";
      private static const _TRANSLATION_DIRECTION__XML_NODE_NAME__TARGET_PHONETIC_TO_NATIVE:String = "targetPhoneticToNative";

      private static var _index_translationDirection_to_xmlNodeName:Dictionary;
      private static var _translationCheckData:Dictionary; // Nested Dictionaries - targetLangIso639_3Code.nativeLangIso639_3Code.translationDirection.translationCheckList

      public function TranslationCheckProcessor() {
      }

      public static function getListOfFailedTranslationChecks(chunkAnalyzer:Analyzer_ScriptChunk_Default):Array {
         initIfNeeded();
         var result:Array = [];
         var targetLanguageSubDictionary:Dictionary = _translationCheckData[chunkAnalyzer.targetLanguageIso639_3Code];
         if (!targetLanguageSubDictionary)
            return [];
         var nativeLanguageSubDictionary:Dictionary = targetLanguageSubDictionary[chunkAnalyzer.nativeLanguageIso639_3Code];
         if (!nativeLanguageSubDictionary)
            return [];
         for each (var translationDirection:String in TranslationCheck.TRANSLATION_DIRECTION_LIST) {
            var directionSubList:Array = nativeLanguageSubDictionary[translationDirection];
            for each (var translationCheckDefinition:TranslationCheckDefinition in directionSubList) {
               var translationCheck:TranslationCheck = new TranslationCheck(translationCheckDefinition, chunkAnalyzer);
               if (translationCheck.isProblematic())

                  // For debugging
                  //translationCheck.isProblematic();


                  result.push(translationCheck);
            }
         }
         return result;
      }

      private static function getTranslationDirectionXmlNodeNameFromTranslationDirection(translationDirection:String):String {
         return _index_translationDirection_to_xmlNodeName[translationDirection];
      }

      // TODO - check config XML first, report problems, don't assume that there's content
      private static function initIfNeeded():void {
         if (!_index_translationDirection_to_xmlNodeName) {
            _index_translationDirection_to_xmlNodeName = new Dictionary();
            _index_translationDirection_to_xmlNodeName[TranslationCheck.TRANSLATION_DIRECTION__NATIVE_TO_TARGET] = _TRANSLATION_DIRECTION__XML_NODE_NAME__NATIVE_TO_TARGET;
            _index_translationDirection_to_xmlNodeName[TranslationCheck.TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC] = _TRANSLATION_DIRECTION__XML_NODE_NAME__NATIVE_TO_TARGET_PHONETIC;
            _index_translationDirection_to_xmlNodeName[TranslationCheck.TRANSLATION_DIRECTION__TARGET_TO_NATIVE] = _TRANSLATION_DIRECTION__XML_NODE_NAME__TARGET_TO_NATIVE;
            _index_translationDirection_to_xmlNodeName[TranslationCheck.TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE] = _TRANSLATION_DIRECTION__XML_NODE_NAME__TARGET_PHONETIC_TO_NATIVE;
         }
         if (_translationCheckData is Dictionary)
            return;
         _translationCheckData = new Dictionary();
         var targetLanguageXMLList:XMLList = MainModel.getInstance().xmlConfigData_TargetLanguages.targetLanguage;
         for each (var targetLanguageXml:XML in targetLanguageXMLList) {
            var targetLanguageIso639_3Code:String = targetLanguageXml.iso639_3Code[0].toString();
            var index_nativeLangIso639_3Code_to_translationDirectionIndex:Dictionary = new Dictionary();
            _translationCheckData[targetLanguageIso639_3Code] = index_nativeLangIso639_3Code_to_translationDirectionIndex;
            var nativeLanguageXMLList:XMLList = targetLanguageXml.nativeLanguages[0].nativeLanguage;
            for each (var nativeLanguageXml:XML in nativeLanguageXMLList) {
               var nativeLanguageIso639_3Code:String = nativeLanguageXml.iso639_3Code[0].toString();
               var index_translationDirection_to_translationCheckList:Dictionary = new Dictionary();
               index_nativeLangIso639_3Code_to_translationDirectionIndex[nativeLanguageIso639_3Code] = index_translationDirection_to_translationCheckList;
               for each (var translationDirection:String in TranslationCheck.TRANSLATION_DIRECTION_LIST) {
                  var directionNodeName:String = getTranslationDirectionXmlNodeNameFromTranslationDirection(translationDirection);
                  var directionNodeXMLList:XMLList = nativeLanguageXml.translations[0].child(directionNodeName);
                  if (directionNodeXMLList.length() == 0)
                     continue;
                  var translationXMLList:XMLList = directionNodeXMLList[0].translation;
                  if (translationXMLList.length() == 0)
                     continue;
                  var translationCheckList:Array = [];
                  index_translationDirection_to_translationCheckList[translationDirection] = translationCheckList;
                  for each (var translationXml:XML in translationXMLList) {
                     var fromVal:String = translationXml.from[0].toString();
                     var toVal:String = translationXml.to[0].toString();
                     var toValList:Array = toVal.split(",");
                     var translationCheckDefinition:TranslationCheckDefinition = new TranslationCheckDefinition(nativeLanguageIso639_3Code, targetLanguageIso639_3Code, fromVal, toValList, translationDirection);
                     translationCheckList.push(translationCheckDefinition);
                  }
               }
            }
         }
      }
   }
}
