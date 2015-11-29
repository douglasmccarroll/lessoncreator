package com.brightworks.lessoncreator.analyzers {
   import com.brightworks.constant.Constant_ReleaseType;
   import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_ReleaseType_InvalidReleaseType;
   import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_ReleaseType_LinePrefix;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_Header_ReleaseType extends Analyzer_ScriptLine {

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__RELEASE_TYPE;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__HEADER__RELEASE_TYPE;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_Header_ReleaseType(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
         isHeaderLine = true;
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         var fix:Fix;
         var problem:LessonProblem;
         if (lineText.indexOf("Release Type: ") != 0) {
            fix = new Fix_Line_HeaderEng_ReleaseType_LinePrefix(scriptAnalyzer, this);
            problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               "Header release type line missing prefix",
               LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__RELEASE_TYPE__LINE_PREFIX,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               fix,
               this);
            problemList.push(problem);
         } else {
            switch (getReleaseType()) {
               case Constant_ReleaseType.ALPHA_CAPITALIZED:
               case Constant_ReleaseType.BETA_CAPITALIZED:
               case Constant_ReleaseType.PRODUCTION_CAPITALIZED:
                  break;
               default:
                  fix = new Fix_Line_HeaderEng_ReleaseType_InvalidReleaseType(scriptAnalyzer, this, getReleaseType());
                  problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     "Header release type line with invalid release type",
                     LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__RELEASE_TYPE__INVALID_RELEASE_TYPE,
                     LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                     fix,
                     this);
                  problemList.push(problem);
            }
         }
         return problemList;
      }

      public function getReleaseType():String {
         if (lineText.indexOf("Release Type: ") != 0)
            return "";
         var result:String = lineText.substring(14, lineText.length);
         result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
         return result;
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // We use another, external, method to determine this at this point, so this method isn't used.
         Log.fatal("Analyzer_ScriptLine_Header_ReleaseType.isLineThisType(): Method not implemented");
         return false;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

   }
}

