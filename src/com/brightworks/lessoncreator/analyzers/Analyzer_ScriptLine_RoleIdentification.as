package com.brightworks.lessoncreator.analyzers {
   import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.constants.Constants_Punctuation;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Line_RoleEng_InvalidRole;
   import com.brightworks.lessoncreator.fixes.Fix_Line_RoleEng_NonStandardColon;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_RoleIdentification extends Analyzer_ScriptLine {
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__ROLE_IDENTIFICATION;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__ROLE_IDENTIFICATION;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_RoleIdentification(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         var fix:Fix;
         var problem:LessonProblem;
         var lineString:String = Utils_String.removeWhiteSpaceIncludingLineReturnsFromEndOfString(lineText);
         if (lineString.charAt(lineString.length - 1) == Constants_Punctuation.COLON__CHINESE) {
            fix = new Fix_Line_RoleEng_NonStandardColon(scriptAnalyzer, this);
            problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               "Role line has non-standard colon",
               LessonProblem.PROBLEM_TYPE__LINE__ROLE_ENG__NON_STANDARD_COLON,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               fix,
               this);
            problemList.push(problem);
         } else {
            // We know that the line doesn't start with white space, and ends with a colon
            var s:String = lineString.substring(0, lineString.length - 1);
            if (scriptAnalyzer.roleList.indexOf(s) != -1) {
               roleName = s;
            } else {
               fix = new Fix_Line_RoleEng_InvalidRole(scriptAnalyzer, this, s);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Role line has invalid role",
                  LessonProblem.PROBLEM_TYPE__LINE__ROLE_ENG__INVALID_ROLE,
                  LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                  fix,
                  this);
               problemList.push(problem);
            }
         }
         return problemList;
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // "Role" lines have blank lines before and after them and end with ":"
         // We're ignoring the "is this in the header" issue here - that would get caught elsewhere.
         if (lineNum < 2)
            return false;
         if (!Analyzer_ScriptLine_Blank.isLineThisType(lineStringList[lineNum - 2]))
            return false;
         if (lineStringList.length > lineNum) {
            // Check line after line
            if (!Analyzer_ScriptLine_Blank.isLineThisType(lineStringList[lineNum]))
               return false;
         }
         lineString = Utils_String.removeWhiteSpaceIncludingLineReturnsFromEndOfString(lineString);
         if (Constants_Punctuation.COLONS.indexOf(lineString.charAt(lineString.length - 1)) == -1)
            return false;
         return true;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

   }
}

