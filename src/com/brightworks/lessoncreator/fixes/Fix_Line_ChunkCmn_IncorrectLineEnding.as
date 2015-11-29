package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_ChunkCmn_IncorrectLineEnding extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE + ". These lines should usually end with either a period, a question mark or an exclamation mark, or else should end with an ellipsis. This line doesn't end with any of these things.";
        }

        public function Fix_Line_ChunkCmn_IncorrectLineEnding(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
