package com.brightworks.lessoncreator.analyzers {
import com.brightworks.constant.Constant_ReleaseType;
import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmnPhonetic_ContainsRestrictedContent;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmnPhonetic_FewToneNumerals;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmnPhonetic_InappropriateCharacters;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding_Ellipsis;
   import com.brightworks.lessoncreator.fixes.Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding_EllipsisWithoutPrecedingSpace;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestriction;
   import com.brightworks.lessoncreator.util.contentrestriction.ContentRestrictionProcessor;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic_CMN extends Analyzer_ScriptLine_Chunk {
      private static const PINYIN_LETTERS_WITH_TONE_MARKS:Array = ["�?","á","ǎ","à","ē","é","ě","è","ī","í","�?","ì","�?","ó","ǒ","ò","ū","ú","ǔ","ù","ǖ","ǘ","ǚ","ǜ","ü"];

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE__PHONETIC;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic_CMN(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
         isChunkLine = true;
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         var toneMarkCharString:String = getToneMarkCharString(lineText);
         var fix:Fix;
         var problem:LessonProblem;
         if (toneMarkCharString.length > 0) {
            fix = new Fix_Line_ChunkCmnPhonetic_InappropriateCharacters(scriptAnalyzer, this, toneMarkCharString);
            problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               "Pinyin line with inappropriate characters",
               LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INAPPROPRIATE_CHARACTERS,
               LessonProblem.PROBLEM_LEVEL__WORRISOME,
               fix,
               this);
            problemList.push(problem);
         } else {
            var numericCharCount:int = Utils_String.getNumericCharacterCount(lineText);
            // The -4 is in case it is a short line ending in ",..."
            var ratio:Number = numericCharCount/(lineText.length - 4);
            if (!((ratio > .1) || (lineText.length < 10))) {
               fix = new Fix_Line_ChunkCmnPhonetic_FewToneNumerals(scriptAnalyzer, this, lineText.length, numericCharCount);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Pinyin line missing tone indicators?",
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__FEW_TONE_NUMERALS,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
               problemList.push(problem);
            }
         }
         if (!isExemptFromPunctuationChecking()) {
            if (lineText.indexOf("…") != -1) {
               fix = new Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding_Ellipsis(scriptAnalyzer, this);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Pinyin line ending in Chinese ellipsis",
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING__ELLIPSIS,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
               problemList.push(problem);
            }
            if (lineText.indexOf("...") != -1) {
               var bProblem:Boolean = false;
               if (lineText.indexOf("...") == (lineText.length - 3)) {
                  if (lineText.charAt(lineText.indexOf("...") - 1) != " ")
                     bProblem = true;
               }
               if (bProblem) {
                  fix = new Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding_EllipsisWithoutPrecedingSpace(scriptAnalyzer, this);
                  problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     "Pinyin line needs space before ellipsis",
                     LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING__ELLIPSIS_WITHOUT_PRECEDING_SPACE,
                     LessonProblem.PROBLEM_LEVEL__WORRISOME,
                     fix,
                     this);
                  problemList.push(problem);
               }
            }
            if (!Utils_String.doesStringEndWithString(lineText, [".", "?", "!", "...", ".)", '."', "!)", '!"', "?)", '?"', ".�?", "!�?", "?�?", "》", ":"])) {
               fix = new Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding(scriptAnalyzer, this);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Pinyin line with incorrect ending",
                  LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING,
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
                  fix = new Fix_Line_ChunkCmnPhonetic_ContainsRestrictedContent(scriptAnalyzer, this, contentRestriction);
                  problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     "Pinyin line contains restricted content: " + contentRestriction.restrictedContent,
                     LessonProblem.PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__CONTAINS_RESTRICTED_CONTENT,
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
         Log.fatal("Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic_CMN.isLineThisType(): Method not implemented");
         return false;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      private function getToneMarkCharString(s:String):String {
         var result:String = "";
         for (var i:int = 0; i < s.length; i++) {
            if (PINYIN_LETTERS_WITH_TONE_MARKS.indexOf(s.charAt(i)) != -1)
               result += s.charAt(i);
         }
         return result;
      }

   }
}
