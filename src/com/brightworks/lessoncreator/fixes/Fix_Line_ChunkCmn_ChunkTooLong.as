package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_ChunkCmn_ChunkTooLong extends Fix_Line {
        public var chineseNonPunctuationCharCount:uint;
        public var recommendedCharCountLimit:uint;

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE + ", and should usually contain a maximum of " + recommendedCharCountLimit + " Chinese characters. This line contains " + chineseNonPunctuationCharCount + ". Is there some way to break this chunk up into multiple chunks? " + Constants_Misc.IGNORE_PROBLEMS__USE_COMMENT_FOR_EXCEPTIONS_SENTENCE;
        }

        public function Fix_Line_ChunkCmn_ChunkTooLong(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, recommendedCharCountLimit:uint, chineseNonPunctuationCharCount:uint) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.chineseNonPunctuationCharCount = chineseNonPunctuationCharCount;
            this.recommendedCharCountLimit = recommendedCharCountLimit;
        }
    }
}
