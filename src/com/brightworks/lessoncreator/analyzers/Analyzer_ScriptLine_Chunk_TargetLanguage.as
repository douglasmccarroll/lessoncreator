package com.brightworks.lessoncreator.analyzers {
import com.brightworks.constant.Constant_ReleaseType;
import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmn_ChunkTooLong;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmn_ContainsRestrictedContent;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmn_IncorrectEllipsis;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmn_IncorrectLineEnding;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmn_TooFewCmnCharacters;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmn_InappropriatePunctuation;
   import com.brightworks.lessoncreator.fixes.Fix_Line_Chunk_ChunkTooLong;
   import com.brightworks.lessoncreator.model.MainModel;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestriction;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestrictionProcessor;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_Chunk_TargetLanguage extends Analyzer_ScriptLine_Chunk {
      private static const LINE_CHAR_COUNT_RECOMMENDED_LIMIT:int = 77;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_Chunk_TargetLanguage(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
         isChunkLine = true;
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         var fix:Fix;
         var problem:LessonProblem;
         if (lineText.length > LINE_CHAR_COUNT_RECOMMENDED_LIMIT) {
            fix = new Fix_Line_Chunk_ChunkTooLong(scriptAnalyzer, this, LINE_CHAR_COUNT_RECOMMENDED_LIMIT, lineText.length);
            problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               MainModel.getInstance().languageConfigInfo.getChunkLineStyleName_Target(scriptAnalyzer.targetLanguageISO639_3Code) + " is too long",
               LessonProblem.PROBLEM_TYPE__LINE__CHUNK__CHUNK_TOO_LONG,
               LessonProblem.PROBLEM_LEVEL__WORRISOME,
               fix,
               this);
            problemList.push(problem);
         }
         return problemList;
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // We use another, external, method to determine this at this point, so this method isn't used.
         Log.fatal("Analyzer_ScriptLine_Chunk_TargetLanguage.isLineThisType(): Method not implemented");
         return false;
      }

   }
}

