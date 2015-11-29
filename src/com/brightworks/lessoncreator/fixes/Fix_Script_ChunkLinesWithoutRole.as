package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script_ChunkLinesWithoutRole extends Fix_Script {

        public var lineAnalyzerList:Array;
        public var lineNumber_FirstLine:uint;

        public override function get humanReadableFixDescription():String {
            return "One or more chunks, starting at line " + lineNumber_FirstLine + ", have no role assigned to them. You have two options. You can either insert a role assignment line before line " + lineNumber_FirstLine + ' or you can remove all existing role assignment lines, in which case Language Mentor will assume a "default" role for all chunks.';
        }

        public function Fix_Script_ChunkLinesWithoutRole(scriptAnalyzer:Analyzer_Script, lineAnalyzerList:Array, lineNumber_FirstLine:uint) {
            super(scriptAnalyzer);
            this.lineAnalyzerList = lineAnalyzerList;
            this.lineNumber_FirstLine = lineNumber_FirstLine;
        }




    }
}
