package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_HeaderEng_LessonId_LinePrefix extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "Based on its position as the 4th line in the script, this line should be the " + Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__LESSON_ID + ", but this doesn't seem to be the case.";
        }

        public function Fix_Line_HeaderEng_LessonId_LinePrefix(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
