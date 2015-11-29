package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_TargetLanguage_LinePrefix;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
    import com.brightworks.util.Utils_String;

    public class Analyzer_ScriptLine_Header_TargetLanguage extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__TARGET_LANGUAGE;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__HEADER__TARGET_LANGUAGE;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Header_TargetLanguage(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isHeaderLine = true;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            if (Utils_String.removeWhiteSpaceIncludingLineReturnsFromEndOfString(lineText) != "Target Language: cmn") {
                var fix:Fix = new Fix_Line_HeaderEng_TargetLanguage_LinePrefix(scriptAnalyzer, this);
                var problem:LessonProblem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Header target language line missing prefix",
                        LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__TARGET_LANGUAGE__LINE_PREFIX,
                        LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                        fix,
                        this);
                problemList.push(problem);
            }
            return problemList;
        }

        public function getTargetLanguage():String {
            if (lineText.indexOf("Target Language: ") != 0)
                return "";
            var result:String = lineText.substring(17, lineText.length);
            result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
            return result;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Header_TargetLanguage.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}

