package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_HeaderEng_LessonSortName_LinePrefix extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "Based on its position as the 3rd line in the script, this line should be the " + Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__LESSON_SORT_NAME + ". It should start with 'Lesson Sort Name:' and if a sort name is provided there should be a space between the colon and the sort name.";
        }

        public function Fix_Line_HeaderEng_LessonSortName_LinePrefix(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
