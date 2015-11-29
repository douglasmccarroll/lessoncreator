package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Chunk_PunctuationMismatch_Ellipsis_TargetToTargetPhonetic extends Fix_Script {

        public var lineNumber_Target:uint;
        public var lineNumber_TargetRomanized:uint;

        public override function get humanReadableFixDescription():String {
            return "Lines " + lineNumber_Target + " and " + lineNumber_TargetRomanized + " should both have an ellipsis or neither should have an ellipsis. Please edit one of these lines so that they correspond.";;
        }

        public function Fix_Chunk_PunctuationMismatch_Ellipsis_TargetToTargetPhonetic(scriptAnalyzer:Analyzer_Script, lineNumber_Target:uint, lineNumber_TargetRomanized:uint) {
            super(scriptAnalyzer);
            this.lineNumber_Target = lineNumber_Target;
            this.lineNumber_TargetRomanized = lineNumber_TargetRomanized;
        }




    }
}
