package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_ChunkCmnPhonetic_FewToneNumerals extends Fix_Line {
        public var numericCharCount:uint;
        public var totalCharCount:uint;

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE__PHONETIC + ", and should contain some numeric characters. This line only contains " + numericCharCount + " numeric characters out of a total of " + totalCharCount + " characters in this line.";
        }

        public function Fix_Line_ChunkCmnPhonetic_FewToneNumerals(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, totalCharCount:uint, numericCharCount:uint) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.numericCharCount = numericCharCount;
            this.totalCharCount = totalCharCount;
        }
    }
}
