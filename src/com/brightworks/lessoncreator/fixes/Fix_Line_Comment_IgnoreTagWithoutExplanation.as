package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_Comment_IgnoreTagWithoutExplanation extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return 'This line says "' + Constants_Misc.SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS + '" but it does not include an explanation.';
        }

        public function Fix_Line_Comment_IgnoreTagWithoutExplanation(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
