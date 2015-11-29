package com.brightworks.lessoncreator.analyzers {
import com.brightworks.lessoncreator.constants.Constants_LessonLevel;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_Level_InvalidLevel;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_Level_LinePrefix;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
    import com.brightworks.util.Utils_String;

    public class Analyzer_ScriptLine_Header_Level extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__LEVEL;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__HEADER__LEVEL;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Header_Level(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isHeaderLine = true;
        }

        public function getLevel():String {
            if (lineText.indexOf("Level: ") != 0)
                return "";
            var result:String = lineText.substring(7, lineText.length);
            result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
            return result;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            var fix:Fix;
            var problem:LessonProblem;
            if (lineText.indexOf("Level: ") != 0) {
                fix = new Fix_Line_HeaderEng_Level_LinePrefix(scriptAnalyzer, this);
                problem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Header level line missing prefix",
                        LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__LEVEL__LINE_PREFIX,
                        LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                        fix,
                        this);
                problemList.push(problem);
            } else {
                switch (getLevel()) {
                    case Constants_LessonLevel.INTRODUCTORY:
                    case Constants_LessonLevel.BEGINNER:
                    case Constants_LessonLevel.INTERMEDIATE:
                    case Constants_LessonLevel.ADVANCED:
                        break;
                    default:
                        fix = new Fix_Line_HeaderEng_Level_InvalidLevel(scriptAnalyzer, this, getLevel());
                        problem = new LessonProblem(
                                scriptAnalyzer.lessonDevFolder,
                                "Header level line with invalid level",
                                LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__LEVEL__INVALID_LEVEL,
                                LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                                fix,
                                this);
                        problemList.push(problem);
                }
            }
            return problemList;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Header_Level.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}

