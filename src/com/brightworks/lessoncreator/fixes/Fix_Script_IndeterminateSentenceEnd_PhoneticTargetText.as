package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script_IndeterminateSentenceEnd_PhoneticTargetText extends Fix_Script {

        public var firstLineNumber:uint;
        public var roleName:String;
        public var secondLineNumber:uint;

        public override function get humanReadableFixDescription():String {
            return "Line " + firstLineNumber + " appears to be the end of a sentence but line " + secondLineNumber + ", which follows it, doesn't start with a capital letter. Please edit one of these lines to fix this problem.";
        }

        public function Fix_Script_IndeterminateSentenceEnd_PhoneticTargetText(scriptAnalyzer:Analyzer_Script, firstLineNumber:uint, secondLineNumber:uint) {
            super(scriptAnalyzer);
            this.firstLineNumber = firstLineNumber;
            this.secondLineNumber = secondLineNumber;
        }




    }
}
