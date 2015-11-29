package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_RoleEng_NonStandardColon extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "This line appears to be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__ROLE_IDENTIFICATION + ", but it uses a Chinese colon instead of an English colon. Please use an English colon here.";
        }

        public function Fix_Line_RoleEng_NonStandardColon(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
