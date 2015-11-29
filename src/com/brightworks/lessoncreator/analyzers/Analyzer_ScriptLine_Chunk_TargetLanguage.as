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
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestriction;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestrictionProcessor;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_Chunk_TargetLanguage extends Analyzer_ScriptLine_Chunk {
      private static const LINE_CHAR_COUNT_HARD_LIMIT:int = 20;
      private static const LINE_CHAR_COUNT_RECOMMENDED_LIMIT:int = 15;
      private static const LINE_CHAR_COUNT_SOFT_LIMIT:int = 16;

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
         var chineseCharCount:uint = Utils_String.getCommonChineseCharacterCount(lineText, true);
         var fix:Fix;
         var problem:LessonProblem;
         var ratio:Number = chineseCharCount/lineText.length;
         if ((ratio < .1) && (lineText.length > 3)) {
            fix = new Fix_Line_ChunkCmn_TooFewCmnCharacters(scriptAnalyzer, this, lineText.length, chineseCharCount);
            problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               "Hanzi line with too few characters",
               LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN__TOO_FEW_CMN_CHARACTERS,
               LessonProblem.PROBLEM_LEVEL__WORRISOME,
               fix,
               this);
            problemList.push(problem);
         }
         if (!isExemptFromPunctuationChecking()) {
            var inappropriatePunctuationString:String = Utils_String.extractCharsFromString(Constants_Misc.PUNCTUATION_LIST__NOT_USED_IN_HANZI, lineText);
            if (inappropriatePunctuationString.length > 0) {
               fix = new Fix_Line_ChunkCmn_InappropriatePunctuation(scriptAnalyzer, this, inappropriatePunctuationString);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Hanzi line with inappropriate punctuation",
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN__WESTERN_STYLE_PUNCTUATION,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
               problemList.push(problem);
            } else {
               // We don't have western-style punctuation, so now we check the
               // hanzi-style punctuation.
               if (lineText.indexOf("…") != lineText.indexOf("……")) {
                  fix = new Fix_Line_ChunkCmn_IncorrectEllipsis(scriptAnalyzer, this);
                  problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     "Hanzi line with incorrect ellipsis",
                     LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN__INCORRECT_ELLIPSIS,
                     LessonProblem.PROBLEM_LEVEL__WORRISOME,
                     fix,
                     this);
                  problemList.push(problem);
               } else {
                  if (!Utils_String.doesStringEndWithString(lineText, ["。", "？", "�?", "……", "。）", '。"', "�?）", '�?"', "？）", '？"', "。�?", "？�?", "�?�?", "》", "：", "！"])) {
                     fix = new Fix_Line_ChunkCmn_IncorrectLineEnding(scriptAnalyzer, this);
                     problem = new LessonProblem(
                        scriptAnalyzer.lessonDevFolder,
                        "Chinese line with incorrect ending",
                        LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN__INCORRECT_LINE_ENDING,
                        LessonProblem.PROBLEM_LEVEL__WORRISOME,
                        fix,
                        this);
                     problemList.push(problem);
                  }
               }
            }
            var chineseNonPunctuationCharCount:int = Utils_String.getCommonChineseCharacterCount(lineText, false);
            if (chineseNonPunctuationCharCount > LINE_CHAR_COUNT_SOFT_LIMIT) {
               fix = new Fix_Line_ChunkCmn_ChunkTooLong(scriptAnalyzer, this, LINE_CHAR_COUNT_RECOMMENDED_LIMIT, chineseNonPunctuationCharCount);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Hanzi line is too long",
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN__CHUNK_TOO_LONG,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
               problemList.push(problem);
            }
         }
         if (scriptAnalyzer.releaseType == Constant_ReleaseType.ALPHA_CAPITALIZED) {
            var restrictedContentList:Array = ContentRestrictionProcessor.getListOfRestrictedContentContainedInString(lineText);
            if (restrictedContentList.length > 0) {
               for each (var contentRestriction:ContentRestriction in restrictedContentList) {
                  fix = new Fix_Line_ChunkCmn_ContainsRestrictedContent(scriptAnalyzer, this, contentRestriction);
                  problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     "Hanzi line contains restricted content: " + contentRestriction.restrictedContent,
                     LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN__CONTAINS_RESTRICTED_CONTENT,
                     LessonProblem.PROBLEM_LEVEL__WORRISOME,
                     fix,
                     this);
                  problemList.push(problem);
               }
            }
         }
         return problemList;
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // We use another, external, method to determine this at this point, so this method isn't used.
         Log.fatal("Analyzer_ScriptLine_Chunk_TargetLanguage.isLineThisType(): Method not implemented");
         return false;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

   }
}

