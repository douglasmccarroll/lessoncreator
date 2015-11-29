package com.brightworks.lessoncreator.analyzers {
   import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkEng_ContainsRestrictedContent;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkEng_IncorrectLineEnding;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestriction;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestrictionProcessor;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_Chunk_NativeLanguage extends Analyzer_ScriptLine_Chunk {
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__NATIVE_LANGUAGE;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_Chunk_NativeLanguage(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
         isChunkLine = true;
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         if (!isExemptFromPunctuationChecking()) {
            if (!Utils_String.doesStringEndWithString(lineText, [".", "?", "!", "...", ".)", '."', "!)", '!"', "?)", '?"', ".�?", "?�?", "!�?", ')"', ")�?", '")', "�?)", ":"])) {
               var fix:Fix = new Fix_Line_ChunkEng_IncorrectLineEnding(scriptAnalyzer, this);
               var problem:LessonProblem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "English line with incorrect ending",
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_ENG__INCORRECT_LINE_ENDING,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
               problemList.push(problem);
            }
         }
         var restrictedContentList:Array = ContentRestrictionProcessor.getListOfRestrictedContentContainedInString(lineText);
         if (restrictedContentList.length > 0) {
            for each (var contentRestriction:ContentRestriction in restrictedContentList) {
               fix = new Fix_Line_ChunkEng_ContainsRestrictedContent(scriptAnalyzer, this, contentRestriction);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "English line contains restricted content: " + contentRestriction.restrictedContent,
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_ENG__CONTAINS_RESTRICTED_CONTENT,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
               problemList.push(problem);
            }
         }
         return problemList;
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // We use another, external, method to determine this at this point, so this method isn't used.
         Log.fatal("Analyzer_ScriptLine_Chunk_NativeLanguage.isLineThisType(): Method not implemented");
         return false;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

   }
}
