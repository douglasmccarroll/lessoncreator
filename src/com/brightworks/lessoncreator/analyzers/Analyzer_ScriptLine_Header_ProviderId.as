package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_ProviderId_LinePrefix;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
    import com.brightworks.util.Utils_String;

    public class Analyzer_ScriptLine_Header_ProviderId extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__PROVIDER_ID;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__HEADER__PROVIDER_ID;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Header_ProviderId(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isHeaderLine = true;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            if (lineText.indexOf("Provider ID: ") != 0) {
                var fix:Fix = new Fix_Line_HeaderEng_ProviderId_LinePrefix(scriptAnalyzer, this);
                var problem:LessonProblem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Header provider ID line missing prefix",
                        LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__PROVIDER_ID__LINE_PREFIX,
                        LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                        fix,
                        this);
                problemList.push(problem);
            }
            return problemList;
        }

        public function getProviderId():String {
            if (lineText.indexOf("Provider ID: ") != 0)
                return "";
            var result:String = lineText.substring(13, lineText.length);
            result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
            return result;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Header_ProviderId.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}

