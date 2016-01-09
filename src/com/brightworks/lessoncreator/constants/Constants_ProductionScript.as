package com.brightworks.lessoncreator.constants {
import com.brightworks.util.Log;

public class Constants_ProductionScript {
      public static const AUDIO_RECORDING__PAID_FOR_UNIT__CHARACTER:String = "Character";
      public static const AUDIO_RECORDING__PAID_FOR_UNIT__WORD:String = "Word";
      public static const CURRENCY_RENMINBI:String = "renminbi";
      public static const CURRENCY_DOLLARS_USA:String = "usa_dollars";
      public static const LANGUAGE_TYPE__BOTH:String = "LANGUAGE_TYPE__BOTH";
      public static const LANGUAGE_TYPE__NATIVE:String = "LANGUAGE_TYPE__NATIVE";
      public static const LANGUAGE_TYPE__TARGET:String = "LANGUAGE_TYPE__TARGET";
      public static const ROLE_SELECTION_MODE__ALL_ROLES:String = "ROLE_SELECTION_MODE__ALL_ROLES";
      public static const ROLE_SELECTION_MODE__SELECTED_ROLES_FOR_EACH_LESSON:String = "ROLE_SELECTION_MODE__SELECTED_ROLES_FOR_EACH_LESSON";
      public static const ROLE_SELECTION_MODE__DISPLAY_NAME__ALL_ROLES:String = "Include All Roles";
      public static const ROLE_SELECTION_MODE__DISPLAY_NAME__SELECTED_ROLES_FOR_EACH_LESSON:String = "Select Roles";
      public static const SCRIPT_LINE_TYPE_INDICATOR__NON_RECORDED__BEGINNING:String = "[ ";
      public static const SCRIPT_LINE_TYPE_INDICATOR__NON_RECORDED__ENDING:String = " ]";
      public static const SCRIPT_LINE_TYPE_INDICATOR__QUICK_RECORDED__BEGINNING:String = "++  ";
      public static const SCRIPT_LINE_TYPE_INDICATOR__QUICK_RECORDED__ENDING:String = "  ++";
      public static const SCRIPT_TYPE__AUDIO_CHECKING_AND_EDITING:String = "SCRIPT_TYPE__AUDIO_CHECKING_AND_EDITING";
      public static const SCRIPT_TYPE__AUDIO_RECORDING:String = "SCRIPT_TYPE__AUDIO_RECORDING";
      public static const SCRIPT_TYPE__FINAL_ALPHA_CHECK:String = "SCRIPT_TYPE__FINAL_ALPHA_CHECK";
      public static const SCRIPT_TYPE__DISPLAY_NAME__AUDIO_CHECKING_AND_EDITING:String = "Audio Checking/Editing Script";
      public static const SCRIPT_TYPE__DISPLAY_NAME__AUDIO_RECORDING:String = "Audio Recording Script";
      public static const SCRIPT_TYPE__DISPLAY_NAME__FINAL_ALPHA_CHECK:String = "Final Alpha Check Script";

      public static const AUDIO_RECORDING_PAID_FOR_UNIT__CMN:String = AUDIO_RECORDING__PAID_FOR_UNIT__CHARACTER;
      public static const AUDIO_RECORDING_PAID_FOR_UNIT__ENG:String = AUDIO_RECORDING__PAID_FOR_UNIT__WORD;

      public function Constants_ProductionScript() {
      }

      public static function getAudioRecordingPaidForUnitForLanguage(iso639_3code:String):String {
         switch (iso639_3code) {
            case Constants_Language.ISO_639_3_CODE__CMN:
               return AUDIO_RECORDING_PAID_FOR_UNIT__CMN;
            case Constants_Language.ISO_639_3_CODE__ENG:
               return AUDIO_RECORDING_PAID_FOR_UNIT__ENG;
            default:
               Log.error("Constants_ProductionScript.getAudioRecordingPaidForUnitForLanguage(): No case for iso639_3code: " + iso639_3code);
         }
         return null;
      }

      public static function getFileNameSuffixForScriptType(scriptType:String):String {
         var result:String;
         switch (scriptType) {
            case SCRIPT_TYPE__AUDIO_CHECKING_AND_EDITING:
               result = "_audio_checking_and_editing";
               break;
            case SCRIPT_TYPE__AUDIO_RECORDING:
               result = "";
               break;
            case SCRIPT_TYPE__FINAL_ALPHA_CHECK:
               result = "_final_alpha_check";
               break;
            default:
               Log.error("Constants_ProductionScript.getFileNameSuffixForScriptType(): No case for: " + scriptType);
         }
         return result;
      }
   }
}
