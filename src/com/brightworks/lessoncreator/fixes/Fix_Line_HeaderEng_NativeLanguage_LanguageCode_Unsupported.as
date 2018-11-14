package com.brightworks.lessoncreator.fixes {
import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_HeaderEng_NativeLanguage_LanguageCode_Unsupported extends Fix_Line {

   public var languageCode:String;

   public override function get humanReadableFixDescription():String {
      return "Based on its position as the 7th line in the script, this line should be the " + Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__NATIVE_LANGUAGE + ". You've specified a language code of " + '"' + languageCode + '"' + " This is either a) not a correct ISO 639-3 language code, b) a code for a language that " + Constants_Misc.APPLICATION_NAME + "doesn't currently support. Please either change the code or contact us at " + Constants_Misc.LANGCOLLAB_FORUMS_URL + " and ask us to add " + '"' + languageCode + '"' + " to the languages that we support.";
   }

   public function Fix_Line_HeaderEng_NativeLanguage_LanguageCode_Unsupported(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
      super(scriptAnalyzer, lineTypeAnalyzer);
   }
}
}
