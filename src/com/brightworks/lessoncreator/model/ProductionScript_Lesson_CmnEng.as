package com.brightworks.lessoncreator.model {
   import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
   import com.brightworks.lessoncreator.constants.Constants_ProductionScript;

   public class ProductionScript_Lesson_CmnEng extends ProductionScript_Lesson {
      public function ProductionScript_Lesson_CmnEng(
         productionScriptLessonOrRoleItem:ProductionScriptLessonOrRoleItem,
         scriptType:String,
         languageType:String,
         roleSelectionMode:String,
         voiceTalent:VoiceTalent) {
         super(productionScriptLessonOrRoleItem, scriptType, languageType, roleSelectionMode, voiceTalent);
         audioRecordingPaidForUnit_NativeLanguage = Constants_ProductionScript.AUDIO_RECORDING_PAID_FOR_UNIT__ENG;
         audioRecordingPaidForUnit_TargetLanguage = Constants_ProductionScript.AUDIO_RECORDING_PAID_FOR_UNIT__CMN;
      }
   }
}
