package com.brightworks.lessoncreator.model {
   import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
   import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk;
   import com.brightworks.lessoncreator.constants.Constants_Language;
import com.brightworks.lessoncreator.constants.Constants_LessonLevel;
import com.brightworks.lessoncreator.constants.Constants_ProductionScript;
   import com.brightworks.lessoncreator.model.ProductionScript;
   import com.brightworks.lessoncreator.model.ProductionScript;
   import com.brightworks.lessoncreator.model.ProductionScript;
   import com.brightworks.lessoncreator.model.ProductionScript;
   import com.brightworks.lessoncreator.model.ProductionScript_Lesson;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_DateTime;
   import com.brightworks.util.Utils_String;

   public class ProductionScript_Lesson {
      protected var audioRecordingPaidForUnit_NativeLanguage:String;
      protected var audioRecordingPaidForUnit_TargetLanguage:String;

      private var _languageType:String;
      private var _lessonDevFolder:LessonDevFolder;
      private var _roleName:String;
      private var _roleSelectionMode:String;
      private var _scriptAnalyzer:Analyzer_Script;
      private var _scriptType:String;
      private var _voiceTalent:VoiceTalent;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get lessonName():String {
         return _lessonDevFolder.lessonName;
      }

      public function get level():String {
         return _lessonDevFolder.level;
      }

      public function get roleName():String {
         return _roleName;
      }

      public function get scriptText():String {
         return createScriptText();
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function ProductionScript_Lesson(
         productionScriptLessonOrRoleItem:ProductionScriptLessonOrRoleItem,
         scriptType:String,
         languageType:String,
         roleSelectionMode:String,
         voiceTalent:VoiceTalent) {
         _languageType = languageType;
         _lessonDevFolder = productionScriptLessonOrRoleItem.lessonDevFolder;
         _roleName = productionScriptLessonOrRoleItem.roleName;
         _roleSelectionMode = roleSelectionMode;
         _scriptAnalyzer = productionScriptLessonOrRoleItem.lessonDevFolder.scriptAnalyzer;
         _scriptType = scriptType;
         _voiceTalent = voiceTalent;
      }

      public function computeAudioRecordingPayment():uint {
         var result:uint = Math.ceil(computeAudioRecordingPaidForUnitCount() * _voiceTalent.paymentPerUnitRate);
         return result;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private function computeAudioRecordingPaidForUnitCount():uint {
         var result:uint = 0;
         for (var chunkNum:uint = 1; chunkNum <= _scriptAnalyzer.chunkCount; chunkNum++) {
            var chunkAnalyzer:Analyzer_ScriptChunk = _scriptAnalyzer.getChunkAnalyzer(chunkNum);
            result += computeAudioRecordingPaidForUnitCount_Chunk(chunkAnalyzer);
         }
         result += computeAudioRecordingPaidForUnitCount_AgreementText();
         return result;
      }

      private function computeAudioRecordingPaidForUnitCount_AgreementText():uint {
         var result:uint;
         // Dummy zero payment, so we need to add some units to cover unit count for actual amount,
         // but the extra line-type-indicator chars more than compensate.
         var text:String = getAudioRecordingAgreementText(0);
         switch (getAudioRecordingPaidForUnit()) {
            case Constants_ProductionScript.AUDIO_RECORDING__PAID_FOR_UNIT__CHARACTER:
               result = text.length;
               break;
            case Constants_ProductionScript.AUDIO_RECORDING__PAID_FOR_UNIT__WORD:
               result = Utils_String.getWordCountForString(text);
               break;
            default:
               Log.error("ProductionScript_Lesson.computePaidForUnitCount(): No match for paidForUnit of: " + getAudioRecordingPaidForUnit());
         }
         return result;
      }

      private function computeAudioRecordingPaidForUnitCount_Chunk(chunkAnalyzer:Analyzer_ScriptChunk):uint {
         // Currently, only audio recording scripts use this method, and thus language type is native or target, but not both
         if (!isChunkRoleIncludedRole(chunkAnalyzer))
            return 0;
         var result:uint;
         var lineText:String;
         switch (_languageType) {
            case Constants_ProductionScript.LANGUAGE_TYPE__NATIVE:
               lineText = chunkAnalyzer.getLineText_Native();
               break;
            case Constants_ProductionScript.LANGUAGE_TYPE__TARGET:
               lineText = chunkAnalyzer.getLineText_Target();
               break;
            default:
               Log.error("ProductionScript_Lesson.computePaidForUnitCount(): No match for _languageType of: " + _languageType);
         }
         switch (getAudioRecordingPaidForUnit()) {
            case Constants_ProductionScript.AUDIO_RECORDING__PAID_FOR_UNIT__CHARACTER:
               result = lineText.length;
               break;
            case Constants_ProductionScript.AUDIO_RECORDING__PAID_FOR_UNIT__WORD:
               result = Utils_String.getWordCountForString(lineText);
               break;
            default:
               Log.error("ProductionScript_Lesson.computePaidForUnitCount(): No match for paidForUnit of: " + getAudioRecordingPaidForUnit());
         }
         return result;
      }

      private function createScriptText():String {
         var result:String = "";
         var lessonNameAndRoleLine:String = lessonName;
         if (_roleName)
            lessonNameAndRoleLine += " - " + _roleName;
         if (_scriptType == Constants_ProductionScript.SCRIPT_TYPE__AUDIO_RECORDING) {
            var langCode:String = ProductionScript.getAudioRecordingISO639_3LanguageCode(_languageType, _scriptAnalyzer);
            result += wrapTextInLineTypeIndicators_NonRecorded(lessonNameAndRoleLine) + "\n";
            result += wrapTextInLineTypeIndicators_NonRecorded(getLessonLevelLine()) + "\n";
            var fileNameLine:String =
                  "File name: " +
                  _voiceTalent.name_Family +
                  "_" +
                  _voiceTalent.name_Given +
                  "_" +
                  Utils_DateTime.getCurrentDateIn_YYYYMMDD_Format() +
                  "_" +
                  _lessonDevFolder.lessonIdFinalSegment;
            if (_roleName)
               fileNameLine += "_" + _roleName;
            result += wrapTextInLineTypeIndicators_NonRecorded(fileNameLine) + "\n";
            var unitCountLine:String = computeAudioRecordingPaidForUnitCount() +
                  " " +
                  getAudioRecordingPaidForUnit() +
                  "s";
            if (_voiceTalent.displayFullPaymentDetail) {
               unitCountLine += " @ " + ProductionScript.adornPaymentAmountWithCurrencyUnit(_voiceTalent.paymentPerUnitRate, _voiceTalent.paymentCurrency);
            }
            unitCountLine = wrapTextInLineTypeIndicators_NonRecorded(unitCountLine);
            result += unitCountLine + "\n";
            if (_voiceTalent.displayFullPaymentDetail) {
               result += wrapTextInLineTypeIndicators_NonRecorded(ProductionScript.adornPaymentAmountWithCurrencyUnit(computeAudioRecordingPayment(), _voiceTalent.paymentCurrency)) + "\n";
            }
            result += "\n";
         } else {
            result += lessonNameAndRoleLine + "\n\n";
         }
         var currChunkRoleName:String;
         for (var chunkNum:uint = 1; chunkNum <= _scriptAnalyzer.chunkCount; chunkNum++) {
            var chunkAnalyzer:Analyzer_ScriptChunk = _scriptAnalyzer.getChunkAnalyzer(chunkNum);
            switch (_scriptType) {
               case Constants_ProductionScript.SCRIPT_TYPE__AUDIO_CHECKING_AND_EDITING:
                  result += createScriptText_Chunk(chunkAnalyzer);
                  break;
               case Constants_ProductionScript.SCRIPT_TYPE__AUDIO_RECORDING:
               case Constants_ProductionScript.SCRIPT_TYPE__FINAL_ALPHA_CHECK:
                  if (currChunkRoleName != chunkAnalyzer.roleName) {
                     currChunkRoleName = chunkAnalyzer.roleName;
                     result += createScriptText_RoleLine(chunkAnalyzer.roleName) + "\n";
                  }
                  result += createScriptText_Chunk(chunkAnalyzer);
                  break;
               default:
                  Log.error("ProductionScript_Lesson.createScriptText(): No case for _scriptType of: " + _scriptType);
            }
         }
         if (_scriptType == Constants_ProductionScript.SCRIPT_TYPE__AUDIO_RECORDING)
            result += "\n" + getAudioRecordingAgreementText(computeAudioRecordingPayment()) + "\n\n\n\n\n";
         else
            result += "\n\n\n\n";
         return result;
      }

      private function createScriptText_Chunk(chunkAnalyzer:Analyzer_ScriptChunk):String {
         var result:String = "";
         var text_Chunk_Native:String = chunkAnalyzer.getLineText_Native();
         var text_Chunk_Target:String = chunkAnalyzer.getLineText_Target();
         var text_Chunk_TargetPhonetic:String = chunkAnalyzer.getLineText_TargetPhonetic();
         var text_ChunkNumber:String = String(chunkAnalyzer.chunkNumber);
         text_Chunk_Native = Utils_String.replaceAll(text_Chunk_Native, "-0-", "");
         text_Chunk_Target = Utils_String.replaceAll(text_Chunk_Target, "-0-", "");
         text_Chunk_TargetPhonetic = Utils_String.replaceAll(text_Chunk_TargetPhonetic, "-0-", "");
         switch (_scriptType) {
            case Constants_ProductionScript.SCRIPT_TYPE__AUDIO_CHECKING_AND_EDITING:
               if (isChunkRoleIncludedRole(chunkAnalyzer)) {
                  result += text_ChunkNumber + "\n";
                  result += text_Chunk_Native + "\n";
                  result += text_Chunk_TargetPhonetic + "\n";
                  result += text_Chunk_Target + "\n";
                  result += "\n";
               }
               break;
            /*case Constants_ProductionScript.SCRIPT_TYPE__AUDIO_EDITING:
               result += text_ChunkNumber + "\n";
               if (isChunkRoleIncludedRole(chunkAnalyzer))
                  text_Chunk_Native = wrapTextInLineTypeIndicators_NonRecorded(text_Chunk_Native);
               result += text_Chunk_Native + "\n";
               if (text_Chunk_TargetPhonetic) {
                  if (isChunkRoleIncludedRole(chunkAnalyzer))
                     text_Chunk_TargetPhonetic = wrapTextInLineTypeIndicators_NonRecorded(text_Chunk_TargetPhonetic);
                  result += text_Chunk_TargetPhonetic + "\n";
               }
               if (isChunkRoleIncludedRole(chunkAnalyzer))
                  text_Chunk_Target = wrapTextInLineTypeIndicators_NonRecorded(text_Chunk_Target);
               result += text_Chunk_Target + "\n";
               result += "\n";
               break;*/
            case Constants_ProductionScript.SCRIPT_TYPE__AUDIO_RECORDING:
               switch (_languageType) {
                  case Constants_ProductionScript.LANGUAGE_TYPE__NATIVE:
                     if (!isChunkRoleIncludedRole(chunkAnalyzer))
                        text_Chunk_Native = wrapTextInLineTypeIndicators_NonRecorded(text_Chunk_Native);
                     result += text_Chunk_Native + "\n";
                     break;
                  case Constants_ProductionScript.LANGUAGE_TYPE__TARGET:
                     if (text_Chunk_TargetPhonetic)
                        result += wrapTextInLineTypeIndicators_NonRecorded(text_Chunk_TargetPhonetic) + "\n";
                     if (!isChunkRoleIncludedRole(chunkAnalyzer))
                        text_Chunk_Target = wrapTextInLineTypeIndicators_NonRecorded(text_Chunk_Target);
                     result += text_Chunk_Target + "\n";
                     break;
                  default:
                     Log.error("ProductionScript_Lesson.createScriptText_Chunk(): In audio recording script, _languageType is neither native nor target");
               }
               if (isChunkRoleIncludedRole(chunkAnalyzer)) {
                  var iso639_3Code:String = ProductionScript.getAudioRecordingISO639_3LanguageCode(_languageType, _scriptAnalyzer);
                  var noteList:Array = chunkAnalyzer.getAudioRecordingNotesForLanguage(iso639_3Code);
                  for each (var note:String in noteList) {
                     result += wrapTextInLineTypeIndicators_NonRecorded("NOTE: " + note) + "\n";
                  }
               }
               result += "\n";
               break;
            case Constants_ProductionScript.SCRIPT_TYPE__FINAL_ALPHA_CHECK:
               result += text_ChunkNumber + "\n";
               result += text_Chunk_Native + "\n";
               noteList =  chunkAnalyzer.getAudioRecordingNotesForLanguage_Native();
               for each (note in noteList) {
                  result += "NOTE: " + note + "\n";
               }
               result += text_Chunk_TargetPhonetic + "\n";
               result += text_Chunk_Target + "\n\n";
               noteList =  chunkAnalyzer.getAudioRecordingNotesForLanguage_Target();
               for each (note in noteList) {
                  result += "NOTE: " + note + "\n";
               }
               break;
            default:
               Log.error("ProductionScript_Lesson.createScriptText_Chunk(): No case for _scriptType of: " + _scriptType);
         }
         return result;
      }

      private function createScriptText_RoleLine(roleName:String):String {
         var result:String = "";
         result += roleName;
         if (_scriptType == Constants_ProductionScript.SCRIPT_TYPE__FINAL_ALPHA_CHECK)
            result += ":"
         else
            result = wrapTextInLineTypeIndicators_NonRecorded(result);
         result += "\n";
         return result;
      }

      private function getAudioRecordingAgreementText(paymentAmount:uint):String {
         var result:String = "";
         // TODO: We're making assumptions here such as 'pay for eng w/ dollars'. This probably won't work long-term.
         // TODO: We may need to configure pay rate and payment unit for each voice talent, or some such...
         var paymentAmountText:String = "";
         switch (ProductionScript.getAudioRecordingISO639_3LanguageCode(_languageType, _scriptAnalyzer)) {
            case Constants_Language.ISO_639_3_CODE__CMN:
               if (_voiceTalent.displayFullPaymentDetail) {
                  paymentAmountText = " " + ProductionScript.adornPaymentAmountWithCurrencyUnit(paymentAmount, _voiceTalent.paymentCurrency);
               }
               var agreementText:String =
                     '我同意，一经付款' +
                     paymentAmountText +
                     '，录音产品将会在"创作共用署名相同方式共享2.5通用"下授权发行。';
               result += wrapTextInLineTypeIndicators_QuickRecorded(agreementText) + "\n";
               // Wo3 tong2yi4, yi1jing1 fu4kuan3  [amount]  yuan2, lu4yin1 chan3pin3 jiang1 hui4 zai4
               // chuang4zuo4 gong4yong4, shu3ming2 xiang1tong2 fang1shi4 gong4xiang3 2.5 tong1yong4 xia4 shou4quan2 fa1xing2.
               break;
            case Constants_Language.ISO_639_3_CODE__ENG:
               if (_voiceTalent.displayFullPaymentDetail) {
                  var possibleS:String = (paymentAmount > 1) ? "s" : "";
                  paymentAmountText = "of " + paymentAmount + " dollar" + possibleS + " to me";
               } else {
                  paymentAmountText = "in full";
               }
               result += wrapTextInLineTypeIndicators_QuickRecorded("I agree that, effective upon payment " + paymentAmountText + ", this recording is") + "\n";
               result += wrapTextInLineTypeIndicators_QuickRecorded("irrevocably released by me under the Creative Commons Attribution-Sharealike license.") + "\n";
               break;
            default:
               Log.error("ProductionScript_Lesson.getAudioRecordingAgreementText(): No match for langCode of: " + ProductionScript.getAudioRecordingISO639_3LanguageCode(_languageType, _scriptAnalyzer));
         }
         return result;
      }

      private function getAudioRecordingPaidForUnit():String {
         var result:String;
         switch (_languageType) {
            case Constants_ProductionScript.LANGUAGE_TYPE__NATIVE:
               result = audioRecordingPaidForUnit_NativeLanguage;
               break;
            case Constants_ProductionScript.LANGUAGE_TYPE__TARGET:
               result = audioRecordingPaidForUnit_TargetLanguage;
               break;
            default:
               Log.error("ProductionScript_Lesson.getAudioRecordingPaidForUnit(): No match for _languageType of: " + _languageType);
         }
         return result;
      }

      private function getLessonLevelLine():String {
         // TODO - It seems that we should have a standard way of getting language-specific display strings
         // TODO - In this case, SomeClass.getLevelDisplayStringForLanguage(level:String, iso639-3Code:String)
         var result:String;
         switch (ProductionScript.getAudioRecordingISO639_3LanguageCode(_languageType, _scriptAnalyzer)) {
            case Constants_Language.ISO_639_3_CODE__CMN:
               result = "课文水平: "
               switch (level) {
                  case Constants_LessonLevel.INTRODUCTORY:
                     result += "新手";
                     break;
                  case Constants_LessonLevel.BEGINNER:
                     result += "初级";
                     break;
                  case Constants_LessonLevel.INTERMEDIATE:
                     result += "中级";
                     break;
                  case Constants_LessonLevel.ADVANCED:
                     result += "高级";
                     break;
                  default:
                     Log.error("ProductionScript_Lesson.getLessonLevelLine(): No case for level: " + level);
               }
               break;
            case Constants_Language.ISO_639_3_CODE__ENG:
               result = "Lesson Level: "
               switch (level) {
                  case Constants_LessonLevel.INTRODUCTORY:
                     result += "Introductory";
                     break;
                  case Constants_LessonLevel.BEGINNER:
                     result += "Beginner";
                     break;
                  case Constants_LessonLevel.INTERMEDIATE:
                     result += "Intermediate";
                     break;
                  case Constants_LessonLevel.ADVANCED:
                     result += "Advanced";
                     break;
                  default:
                     Log.error("ProductionScript_Lesson.getLessonLevelLine(): No case for level: " + level);
               }
               break;
            default:
               Log.error("ProductionScript_Lesson.getLessonLevelLine(): No match for langCode of: " + ProductionScript.getAudioRecordingISO639_3LanguageCode(_languageType, _scriptAnalyzer));
         }
         return result;
      }

      private function isChunkRoleIncludedRole(chunkAnalyzer:Analyzer_ScriptChunk):Boolean {
         var result:Boolean = true;
         if ((_roleSelectionMode == Constants_ProductionScript.ROLE_SELECTION_MODE__SELECTED_ROLES_FOR_EACH_LESSON) &&
            (chunkAnalyzer.roleName != _roleName))
            result = false;
         return result;
      }

      private function wrapTextInLineTypeIndicators_NonRecorded(s:String):String {
         return Constants_ProductionScript.SCRIPT_LINE_TYPE_INDICATOR__NON_RECORDED__BEGINNING + s + Constants_ProductionScript.SCRIPT_LINE_TYPE_INDICATOR__NON_RECORDED__ENDING;
      }

      private function wrapTextInLineTypeIndicators_QuickRecorded(s:String):String {
         return Constants_ProductionScript.SCRIPT_LINE_TYPE_INDICATOR__QUICK_RECORDED__BEGINNING + s + Constants_ProductionScript.SCRIPT_LINE_TYPE_INDICATOR__QUICK_RECORDED__ENDING;
      }



   }
}




















