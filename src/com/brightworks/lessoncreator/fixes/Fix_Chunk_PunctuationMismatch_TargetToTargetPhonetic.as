package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Chunk_PunctuationMismatch_TargetToTargetPhonetic extends Fix_Script {

        public var combinedPunctuationString_Target:String;
        public var combinedPunctuationString_TargetRomanized:String;
        public var lineNumber_Target:uint;
        public var lineNumber_TargetRomanized:uint;

        public override function get humanReadableFixDescription():String {
            var result:String = "";
            result += scriptAnalyzer.getChunkLineStyleName_Target(true) + " and " + scriptAnalyzer.getChunkLineStyleName_TargetRomanized(false) + " lines in the same chunk should have 'corresponding' punctuation. In specific, this means:\n";
            result += Constants_Misc.CHINESE_PUNCTUATION_RULES + "\n";
            result += "The punctuation for lines " + lineNumber_Target + " and " + lineNumber_TargetRomanized + " don't correspond:\n";
            result += "   Line " + lineNumber_Target + ":  " + combinedPunctuationString_Target + "\n";
            result += "   Line " + lineNumber_TargetRomanized + " has these punctuation characters:  " + combinedPunctuationString_TargetRomanized + "\n";
            result += "Please edit one or both of these lines so that their punctuation corresponds.";
            return result;
        }

        public function Fix_Chunk_PunctuationMismatch_TargetToTargetPhonetic(
                scriptAnalyzer:Analyzer_Script,
                lineNumber_Target:uint,
                lineNumber_TargetRomanized:uint,
                combinedPunctuationString_Target:String,
                combinedPunctuationString_TargetRomanized:String) {
            super(scriptAnalyzer);
            this.combinedPunctuationString_Target = combinedPunctuationString_Target;
            this.combinedPunctuationString_TargetRomanized = combinedPunctuationString_TargetRomanized;
            this.lineNumber_Target = lineNumber_Target;
            this.lineNumber_TargetRomanized = lineNumber_TargetRomanized;
        }




    }
}
