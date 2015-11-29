package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkNoteEng_IncorrectLineBeginning;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;

    public class Analyzer_ScriptLine_Chunk_Note extends Analyzer_ScriptLine_Chunk {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__NOTE;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__CHUNK__NOTE;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Chunk_Note(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isChunkLine = true;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            if (lineText.indexOf("Note: ") != 0) {
                var fix:Fix = new Fix_Line_ChunkNoteEng_IncorrectLineBeginning(scriptAnalyzer, this);
                var problem:LessonProblem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Note line incorrect beginning",
                        LessonProblem.PROBLEM_TYPE__LINE__CHUNK_NOTE_ENG__INCORRECT_LINE_BEGINNING,
                        LessonProblem.PROBLEM_LEVEL__WORRISOME,
                        fix,
                        this);
                problemList.push(problem);
            }
            return problemList;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Chunk_Note.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}
