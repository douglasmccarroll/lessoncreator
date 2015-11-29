package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_LibraryId_LinePrefix;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
    import com.brightworks.util.Utils_String;

    public class Analyzer_ScriptLine_Header_LibraryId extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__LIBRARY_ID;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__HEADER__LIBRARY_ID;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Header_LibraryId(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isHeaderLine = true;
        }

        public function getLibraryId():String {
            if (lineText.indexOf("Library ID: ") != 0)
                return "";
            var result:String = lineText.substring(12, lineText.length);
            result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
            return result;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            if (lineText.indexOf("Library ID: ") != 0) {
                var fix:Fix = new Fix_Line_HeaderEng_LibraryId_LinePrefix(scriptAnalyzer, this);
                var problem:LessonProblem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Header library ID line missing prefix",
                        LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__LIBRARY_ID__LINE_PREFIX,
                        LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                        fix,
                        this);
                problemList.push(problem);
            }
            return problemList;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Header_LibraryId.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}

