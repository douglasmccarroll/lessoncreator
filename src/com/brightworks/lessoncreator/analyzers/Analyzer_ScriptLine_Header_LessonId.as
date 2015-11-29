package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_LessonId_LinePrefix;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
    import com.brightworks.util.Utils_String;

    public class Analyzer_ScriptLine_Header_LessonId extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__LESSON_ID;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__HEADER__LESSON_ID;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Header_LessonId(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isHeaderLine = true;
        }

        public function getLessonId():String {
            if (lineText.indexOf("Lesson ID: ") != 0)
                return "";
            var result:String = lineText.substring(11, lineText.length);
            result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
            return result;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            if (lineText.indexOf("Lesson ID: ") != 0) {
                var fix:Fix = new Fix_Line_HeaderEng_LessonId_LinePrefix(scriptAnalyzer, this);
                var problem:LessonProblem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Header lesson ID line missing prefix",
                        LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_ID__LINE_PREFIX,
                        LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                        fix,
                        this);
                problemList.push(problem);
            }
            return problemList;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Header_LessonId.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}

