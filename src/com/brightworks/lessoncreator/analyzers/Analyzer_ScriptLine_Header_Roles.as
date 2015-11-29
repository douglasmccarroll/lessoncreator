package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
    import com.brightworks.lessoncreator.constants.Constants_Misc;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_Roles_InvalidRoleInfo;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_Roles_LinePrefix;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;

    public class Analyzer_ScriptLine_Header_Roles extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__ROLES;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__HEADER__ROLES;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Header_Roles(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
            isHeaderLine = true;
        }

        override public function getProblems():Array {
            var problemList:Array = [];
            var fix:Fix;
            var problem:LessonProblem;
            var isLineBeginningCorrect:Boolean = false;
            // We allow "Roles:" in cases where no roles are declared - but we don't currently check to make sure that this is the case
            if ((lineText.indexOf("Roles: ") == 0) || (lineText == "Roles:")) {
                isLineBeginningCorrect = true;
            }
            if (!isLineBeginningCorrect) {
                fix = new Fix_Line_HeaderEng_Roles_LinePrefix(scriptAnalyzer, this);
                problem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Header roles line missing prefix",
                        LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__ROLES__LINE_PREFIX,
                        LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                        fix,
                        this);
                problemList.push(problem);
            } else {
                var roleList:Array = getRoleList();
                var isRoleProblem:Boolean = false;
                switch (roleList.length) {
                    case 0:
                        isRoleProblem = true;
                        break;
                    case 1:
                        // If we have one role, any name is acceptable
                        break;
                    default:
                        if (problemList.indexOf(Constants_Misc.ROLE_DEFAULT) != -1)
                            isRoleProblem = true;
                }
                if (isRoleProblem) {
                    fix = new Fix_Line_HeaderEng_Roles_InvalidRoleInfo(scriptAnalyzer, this);
                    problem = new LessonProblem(
                            scriptAnalyzer.lessonDevFolder,
                            "Header roles line with invalid role info",
                            LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__ROLES__INVALID_ROLE_INFO,
                            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                            fix,
                            this);
                    problemList.push(problem);
                }
            }
            return problemList;
        }

        public function getRoleList():Array {
            if (lineText.indexOf("Roles: ") != 0)
                return [];
            var listString:String = lineText.substring(7, lineText.length);
            if (listString.indexOf(" :") != -1)
                return [];
            if (listString.indexOf(": ") != -1)
                return [];
            var listArray:Array = listString.split(":");
            return listArray;
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            // We use another, external, method to determine this at this point, so this method isn't used.
            Log.fatal("Analyzer_ScriptLine_Header_Roles.isLineThisType(): Method not implemented");
            return false;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}
