package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Line_ChunkNoteEng_IncorrectLineBeginning extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return 'Based on its position as the 4th line in a chunk, this line should be a note line. Note lines should start with "Note: " but this line ' + "doesn't.";
        }

        public function Fix_Line_ChunkNoteEng_IncorrectLineBeginning(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
