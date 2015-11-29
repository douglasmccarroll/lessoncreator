package com.brightworks.lessoncreator.util.translationcheck {
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_String;

import flash.utils.Dictionary;

   public class TranslationCheck {
      public static const TRANSLATION_DIRECTION_LIST:Array = [
         TRANSLATION_DIRECTION__NATIVE_TO_TARGET,
         TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC,
         TRANSLATION_DIRECTION__TARGET_TO_NATIVE,
         TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE];
      public static const TRANSLATION_DIRECTION__NATIVE_TO_TARGET:String = "TRANSLATION_DIRECTION__NATIVE_TO_TARGET";
      public static const TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC:String = "TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC";
      public static const TRANSLATION_DIRECTION__TARGET_TO_NATIVE:String = "TRANSLATION_DIRECTION__TARGET_TO_NATIVE";
      public static const TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE:String = "TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE";

      // TODO i18n
      private static const _TRANSLATION_DIRECTION__ENG_DESCRIPTION__NATIVE_TO_TARGET:String = "native to target";
      private static const _TRANSLATION_DIRECTION__ENG_DESCRIPTION__NATIVE_TO_TARGET_PHONETIC:String = "native to target phonetic";
      private static const _TRANSLATION_DIRECTION__ENG_DESCRIPTION__TARGET_TO_NATIVE:String = "target to native";
      private static const _TRANSLATION_DIRECTION__ENG_DESCRIPTION__TARGET_PHONETIC_TO_NATIVE:String = "target phonetic to native";

      private static var _index_translationDirection_to_engDescription:Dictionary;

      private var _chunkAnalyzer:Analyzer_ScriptChunk;
      private var _translationCheckDefinition:TranslationCheckDefinition;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get humanReadableFixDescription():String {
         var result:String = "Line " + getLineNumber_From() + ' contains the word "' + _translationCheckDefinition.translateFromString + '".\n'
         result += "This word should be translated in line " + getLineNumber_To() + " as one of the following:\n"
         for each (var toString:String in _translationCheckDefinition.translateToStringList) {
            result += "   " + toString + "\n";
         }
         return result;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function TranslationCheck(translationCheckDefinition:TranslationCheckDefinition, chunkAnalyzer:Analyzer_ScriptChunk) {
         _chunkAnalyzer = chunkAnalyzer;
         _translationCheckDefinition = translationCheckDefinition;
         initIfNeeded();
      }

      private static function getTranslationDirectionEngDescriptionFromTranslationDirection(translationDirection:String):String {
         return _index_translationDirection_to_engDescription[translationDirection];
      }

      public function isProblematic():Boolean {
         var fromLine:String = getLine_From();

         //if (fromLine.indexOf("hai2shi4") != -1)
         //   var foo:int = 1;


         var toLine:String = getLine_To();
         fromLine = fromLine.toLowerCase();
         toLine = toLine.toLowerCase();
         if (Utils_String.doesStringContainSubstringSurroundedByLineBreaks_WhiteSpace_Or_Punctuation(fromLine, _translationCheckDefinition.translateFromString.toLowerCase())) {
            for each (var translateToString:String in _translationCheckDefinition.translateToStringList) {
               if (toLine.indexOf(translateToString.toLowerCase()) != -1)
                  return false;
            }
            return true;
         }
         return false;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function getLine_From():String {
         var fromLine:String;
         switch (_translationCheckDefinition.translationDirection) {
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET:
               fromLine = _chunkAnalyzer.getLineText_Native();
               break;
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC:
               fromLine = _chunkAnalyzer.getLineText_Native();
               break;
            case TRANSLATION_DIRECTION__TARGET_TO_NATIVE:
               fromLine = _chunkAnalyzer.getLineText_Target();
               break;
            case TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE:
               fromLine = _chunkAnalyzer.getLineText_TargetPhonetic();
               break;
            default:
               Log.error("TranslationCheck.getFromLine(): No case for " + _translationCheckDefinition.translationDirection);
         }
         return fromLine;
      }

      public function getLine_To():String {
         var toLine:String;
         switch (_translationCheckDefinition.translationDirection) {
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET:
               toLine = _chunkAnalyzer.getLineText_Target();
               break;
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC:
               toLine = _chunkAnalyzer.getLineText_TargetPhonetic();
               break;
            case TRANSLATION_DIRECTION__TARGET_TO_NATIVE:
               toLine = _chunkAnalyzer.getLineText_Native();
               break;
            case TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE:
               toLine = _chunkAnalyzer.getLineText_Native();
               break;
            default:
               Log.error("TranslationCheck.getToLine(): No case for " + _translationCheckDefinition.translationDirection);
         }
         return toLine;
      }

      public function getLineNumber_From():uint {
         var fromLine:uint;
         switch (_translationCheckDefinition.translationDirection) {
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET:
               fromLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE);
               break;
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC:
               fromLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE);
               break;
            case TRANSLATION_DIRECTION__TARGET_TO_NATIVE:
               fromLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
               break;
            case TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE:
               fromLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
               break;
            default:
               Log.error("TranslationCheck.getFromLine(): No case for " + _translationCheckDefinition.translationDirection);
         }
         return fromLine;
      }

      public function getLineNumber_To():uint {
         var toLine:uint;
         switch (_translationCheckDefinition.translationDirection) {
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET:
               toLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
               break;
            case TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC:
               toLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
               break;
            case TRANSLATION_DIRECTION__TARGET_TO_NATIVE:
               toLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE);
               break;
            case TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE:
               toLine = _chunkAnalyzer.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE);
               break;
            default:
               Log.error("TranslationCheck.getToLine(): No case for " + _translationCheckDefinition.translationDirection);
         }
         return toLine;
      }

      private function initIfNeeded():void {
         if (!_index_translationDirection_to_engDescription) {
            _index_translationDirection_to_engDescription = new Dictionary();
            _index_translationDirection_to_engDescription[TRANSLATION_DIRECTION__NATIVE_TO_TARGET] = _TRANSLATION_DIRECTION__ENG_DESCRIPTION__NATIVE_TO_TARGET;
            _index_translationDirection_to_engDescription[TRANSLATION_DIRECTION__NATIVE_TO_TARGET_PHONETIC] = _TRANSLATION_DIRECTION__ENG_DESCRIPTION__NATIVE_TO_TARGET_PHONETIC;
            _index_translationDirection_to_engDescription[TRANSLATION_DIRECTION__TARGET_TO_NATIVE] = _TRANSLATION_DIRECTION__ENG_DESCRIPTION__TARGET_TO_NATIVE;
            _index_translationDirection_to_engDescription[TRANSLATION_DIRECTION__TARGET_PHONETIC_TO_NATIVE] = _TRANSLATION_DIRECTION__ENG_DESCRIPTION__TARGET_PHONETIC_TO_NATIVE;
         }

      }
   }
}
