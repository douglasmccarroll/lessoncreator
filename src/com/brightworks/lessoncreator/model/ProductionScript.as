package com.brightworks.lessoncreator.model {
import com.brightworks.constant.Constant_Private;
import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
   import com.brightworks.lessoncreator.constants.Constants_Language;
   import com.brightworks.lessoncreator.constants.Constants_ProductionScript;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   import mx.collections.ArrayCollection;

   public class ProductionScript {
      public var languageIso639_3Code_Native:String;
      public var languageIso639_3Code_Script:String;
      public var languageIso639_3Code_Target:String;
      public var languageType:String;
      public var productionScriptLessonOrRoleItemList:ArrayCollection;
      public var roleSelectionMode:String;
      public var scriptType:String;
      public var voiceTalent:VoiceTalent;

      private var _lessonProductionScriptList:ArrayCollection;
      private var _model:MainModel = MainModel.getInstance();

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get scriptText():String {
         return createScriptText();
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function ProductionScript(
         scriptType:String,
         productionScriptLessonOrRoleItemList:ArrayCollection,
         languageIso639_3Code_Native:String,
         languageIso639_3Code_Target:String,
         languageIso639_3Code_Script:String = null,
         roleSelectionMode:String = null,
         voiceTalent:VoiceTalent = null) {
         this.languageIso639_3Code_Native = languageIso639_3Code_Native;
         this.languageIso639_3Code_Script = languageIso639_3Code_Script;
         this.languageIso639_3Code_Target = languageIso639_3Code_Target;
         this.productionScriptLessonOrRoleItemList = productionScriptLessonOrRoleItemList;
         this.roleSelectionMode = roleSelectionMode;
         this.scriptType = scriptType;
         this.voiceTalent = voiceTalent;
         if (languageIso639_3Code_Script) {
            switch (languageIso639_3Code_Script) {
               case languageIso639_3Code_Native:
                  languageType = Constants_ProductionScript.LANGUAGE_TYPE__NATIVE;
                  break;
               case languageIso639_3Code_Target:
                  languageType = Constants_ProductionScript.LANGUAGE_TYPE__TARGET;
                  break;
               default:
                  Log.error("ProductionScript constructor: languageIso639_3Code_Script has no match");
            }
         } else {
            languageType = Constants_ProductionScript.LANGUAGE_TYPE__BOTH;
         }
         populateLessonProductionScriptList();
      }

      public static function adornPaymentAmountWithCurrencyUnit(amount:Number, currency:String):String {
         var result:String;
         switch (currency) {
            case Constants_ProductionScript.CURRENCY_DOLLARS_USA:
               result = "$" + String(amount);
               break;
            case Constants_ProductionScript.CURRENCY_RENMINBI:
               result = String(amount) + " RMB";
               break;
            default:
               Log.error("ProductionScript_Lesson.getAudioRecordingAgreementText(): No match for currency: " + currency);
         }
         return result;
      }

      public static function getAudioRecordingISO639_3LanguageCode(languageType:String, scriptAnalyzer:Analyzer_Script):String {
         var result:String = "";
         switch (languageType) {
            case Constants_ProductionScript.LANGUAGE_TYPE__NATIVE:
               result = scriptAnalyzer.nativeLanguageISO639_3Code;
               break;
            case Constants_ProductionScript.LANGUAGE_TYPE__TARGET:
               result = scriptAnalyzer.targetLanguageISO639_3Code;
               break;
            default:
               Log.error("ProductionScript_Lesson.getAudioRecordingISO639_3LanguageCode(): No match for _languageType of: " + languageType);
         }
         return result;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private function createLessonProductionScript(item:ProductionScriptLessonOrRoleItem):ProductionScript_Lesson {
         var result:ProductionScript_Lesson;
         switch (languageIso639_3Code_Native) {
            case Constants_Language.ISO_639_3_CODE__ENG:
               switch (languageIso639_3Code_Target) {
                  case Constants_Language.ISO_639_3_CODE__CMN:
                     result = new ProductionScript_Lesson_CmnEng(item, scriptType, languageType, roleSelectionMode, voiceTalent);
                     break;
                  default:
                     Log.error("ProductionScript.createLessonProductionScript(): No case for target language code of: " + languageIso639_3Code_Target);
               }
               break;
            default:
               Log.error("ProductionScript.createLessonProductionScript(): No case for native language code of: " + languageIso639_3Code_Native);
         }
         return result;
      }

      private function createScriptText():String {
         var result:String = "";
         if (scriptType == Constants_ProductionScript.SCRIPT_TYPE__AUDIO_RECORDING) {
            result += "Voice talent: " + voiceTalent.name_Display + "\n\n";
            result += createScriptText_LessonNameAndPaymentSummary() + "\n\n";
            result += createScriptText_RecordingInstructions() + "\n\n";
         }
         for each (var lessonProductionScript:ProductionScript_Lesson in _lessonProductionScriptList) {
            result += lessonProductionScript.scriptText;
         }
         return result;
      }

      private function createScriptText_LessonNameAndPaymentSummary():String {
         var result:String = "";
         var totalPayment:uint = 0;
         for each (var lessonProductionScript:ProductionScript_Lesson in _lessonProductionScriptList) {
            var roleString:String = (lessonProductionScript.roleName) ? " " + lessonProductionScript.roleName : "";
            result +=
               lessonProductionScript.lessonName +
               roleString +
               ": " +
               adornPaymentAmountWithCurrencyUnit(lessonProductionScript.computeAudioRecordingPayment(), voiceTalent.paymentCurrency) +
               "\n";
            totalPayment += lessonProductionScript.computeAudioRecordingPayment();
         }
         result += "Per-order payment: " + adornPaymentAmountWithCurrencyUnit(voiceTalent.paymentPerOrderBaseRate, voiceTalent.paymentCurrency) + "\n";
         totalPayment += voiceTalent.paymentPerOrderBaseRate;
         if (totalPayment >= voiceTalent.paymentPerOrderMinimum) {
            result += "Total payment: " + " " + adornPaymentAmountWithCurrencyUnit(totalPayment, voiceTalent.paymentCurrency) + "\n";
         } else {
            result += "Total payment (based on minimum): " + " " + adornPaymentAmountWithCurrencyUnit(voiceTalent.paymentPerOrderMinimum, voiceTalent.paymentCurrency) + "\n";
         }
         return result;
      }

      private function createScriptText_RecordingInstructions():String {
         var result:String = "";
         switch (languageIso639_3Code_Script) {
            case Constants_Language.ISO_639_3_CODE__CMN:
               result += "录音说明：\n";
               // Lu4yin1 shuo1ming2:
               // Recording instructions:
               result += "1. 请录制该“录音说明”下面，不含中括号的文字。\n";
               // 1. Qing3 lu4zhi4 gai1 "lu4yin1 shuo1ming2" xia4mian4, bu4 han2 zhong1kuo4hao4 de wen2zi4.
               // 1. Please record this "recording instructions" below, not include/contain square brackets de writing.
               result += "2. ++符号内的文字，录制时无须高质量，录制时可以快速朗读。\n";
               // 2. ++ fu2hao4 nei4 de wen2zi4, lu4zhi4 shi2 wu2xu1 gao1 zhi4liang4, lu4zhi4 shi2 ke3yi3 kuai4su4 lang3du2.
               // 2. ++ symbol within de writing, recording is no-need high quality, recording-when can quickly read aloud.
               result += "3. 文件格式： WAV 32 bit \n";
               // 3. Wen2jian4 ge2shi4: WAV
               // 3. Document format: WAV
               result += "4. 请录单声道。\n";
               // 4. Qing3 lu4 dan1sheng1dao4.
               // 4. Please record mono.
               result += "5. 样本率为44.1KHz\n";
               // 5. Yang4ben3lv4 wei2 44.1 KHz
               // 5. Sample rate is 44.1 KHz
               result += "6. 每一份录音订单包含若干个课程，每个课程的录音文件命名请直接使用每课第三行的File name。\n"
               // 6. Mei3 yi1 fen4 lu4yin1 ding4dan1 bao1han2 ruo4gan1 ge4 ke4cheng2, mei3 ge4 ke4cheng2 de lu4yin1 wen2jian4 ming4ming2 qing3 zhi2jie1 shi3yong4 mei3 ke4 di4san1 hang2 de 'File name'.
               // 6. Each recording order contains a certain number of lessons, each lesson recording file's name - please directly use each lesson third line's 'File name'.
               break;
            case Constants_Language.ISO_639_3_CODE__ENG:
               result += "Recording Instructions:\n";
               result += "1. Please record those lines below these instructions which aren't marked with square brackets ([]).\n";
               result += "2. The lines marked by plus signs (++) can be read quickly, with little regard for audio quality.\n";
               result += "3. Please record in mono, not stereo.\n";
               result += "4. File format: WAV\n";
               result += "5. Sample rate: 44.1 KHz\n";
               result += "6. File name: Please use the file name provided at the beginning of each assignment below.\n";
               result += '7. Please insert a bit of a pause in all cases where you see a " - " (space-hyphen-space).\n';
               result += "8. Please be careful to read carefully - it's easy to " + 'assume "correct English" and to unintentionally "read" words that "should" be there.\n';
               break;
            default:
               Log.error("ProductionScript.getPerOrderAudioRecordingPayment(): No match for langCode of: " + languageIso639_3Code_Target);
         }
         return result;
      }

      private function populateLessonProductionScriptList():void {
         _lessonProductionScriptList = new ArrayCollection();
         for each (var item:ProductionScriptLessonOrRoleItem in productionScriptLessonOrRoleItemList) {
            var lessonProductionScript:ProductionScript_Lesson = createLessonProductionScript(item);
            _lessonProductionScriptList.addItem(lessonProductionScript);
         }
      }

      private function wrapTextInLineTypeIndicators_NonRecorded(s:String):String {
         return Constants_ProductionScript.SCRIPT_LINE_TYPE_INDICATOR__NON_RECORDED__BEGINNING + s + Constants_ProductionScript.SCRIPT_LINE_TYPE_INDICATOR__NON_RECORDED__ENDING;
      }

   }
}




