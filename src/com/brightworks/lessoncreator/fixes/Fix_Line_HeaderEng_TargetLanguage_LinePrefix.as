package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_HeaderEng_TargetLanguage_LinePrefix extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            //  TODO - currently hardcoded for cmn
            return "Based on its position as the 8th line in the script, this line should be the " + Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__TARGET_LANGUAGE + ", and should say 'Target Language: cmn'. This line does not say this. Make sure that both 'Target' and 'Language' are capitalized.";
        }

        public function Fix_Line_HeaderEng_TargetLanguage_LinePrefix(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
