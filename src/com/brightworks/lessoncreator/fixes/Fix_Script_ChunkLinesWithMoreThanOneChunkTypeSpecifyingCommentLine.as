package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script_ChunkLinesWithMoreThanOneChunkTypeSpecifyingCommentLine extends Fix_Script {

        public var lineAnalyzerList:Array;
        public var lineNumber_FirstLine:uint;

        public override function get humanReadableFixDescription():String {
            return "Several lines, starting at line " + lineNumber_FirstLine + ", appear to be a chunk, but they contain more than one comment lines that identify what type of chunk this chunk is. Please remove all but one of these comment lines.";
        }

        public function Fix_Script_ChunkLinesWithMoreThanOneChunkTypeSpecifyingCommentLine(scriptAnalyzer:Analyzer_Script, lineAnalyzerList:Array, lineNumber_FirstLine:uint) {
            super(scriptAnalyzer);
            this.lineAnalyzerList = lineAnalyzerList;
            this.lineNumber_FirstLine = lineNumber_FirstLine;
        }




    }
}
