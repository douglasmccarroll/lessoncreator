package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script_IndeterminateLineType extends Fix_Script {

        public var lineNumber:uint;

        public override function get humanReadableFixDescription():String {
            return "What kind of line is line " + lineNumber + "? It doesn't conform to our script formatting rules. If it's a chunk line it should be in a group of " + scriptAnalyzer.getAllowedNonCommentChunkLineCount_Minimum() + " or " + scriptAnalyzer.getAllowedNonCommentChunkLineCount_Maximum() + " lines. If it's a role line it should end with a colon. Please edit your script to correct this problem.";
        }

        public function Fix_Script_IndeterminateLineType(scriptAnalyzer:Analyzer_Script, lineNumber:uint) {
            super(scriptAnalyzer);
            this.lineNumber = lineNumber;
        }




    }
}
