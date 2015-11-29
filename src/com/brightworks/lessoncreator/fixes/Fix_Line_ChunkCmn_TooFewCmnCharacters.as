package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_ChunkCmn_TooFewCmnCharacters extends Fix_Line {
        public var chineseCharCount:uint;
        public var totalCharCount:uint;

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE + ", and should only contain Chinese characters. This line only contains " + chineseCharCount + " Chinese characters out of " + totalCharCount + " characters in this line. " + Constants_Misc.IGNORE_PROBLEMS__USE_COMMENT_FOR_EXCEPTIONS_SENTENCE;
        }

        public function Fix_Line_ChunkCmn_TooFewCmnCharacters(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, totalCharCount:uint, chineseCharCount:uint) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.chineseCharCount = chineseCharCount;
            this.totalCharCount = totalCharCount;
        }
    }
}
