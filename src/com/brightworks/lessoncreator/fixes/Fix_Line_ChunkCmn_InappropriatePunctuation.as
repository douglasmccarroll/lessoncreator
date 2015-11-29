package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_ChunkCmn_InappropriatePunctuation extends Fix_Line {
        public var inappropriatePunctuationString:String;

        public override function get humanReadableFixDescription():String {
            var result:String = "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE + ", and should use hanzi-style punctuation, except for quotation marks, which should be western-style. Some of the punctuation in this line doesn't follow these rules. Specifically, the following punctuation mark(s) should be replaced in this line:  " + inappropriatePunctuationString + "\n";
            result += "For your reference, are some guidelines on which punctuation marks to use in which lines:\n";
            result += Constants_Misc.CHINESE_PUNCTUATION_RULES;
            return result;
        }

        public function Fix_Line_ChunkCmn_InappropriatePunctuation(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, inappropriatePunctuationString:String) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.inappropriatePunctuationString = inappropriatePunctuationString;
        }
    }
}
