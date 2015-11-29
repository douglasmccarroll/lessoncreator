package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_ChunkCmn_IncorrectEllipsis extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE + ". In these lines ellipses (if any) should be made up of two Chinese ellipsis characters (……). This line contains a single Chinese ellipsis character, which is feeling very lonely.";
        }

        public function Fix_Line_ChunkCmn_IncorrectEllipsis(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
