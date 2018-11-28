package com.brightworks.lessoncreator.analyzers {
   import com.brightworks.lessoncreator.constants.Constants_Language;
   import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Line_Comment_IgnoreTagWithoutExplanation;
   import com.brightworks.lessoncreator.fixes.Fix_Line_Comment_AudioRecordingCommentWithoutLanguageCode;
   import com.brightworks.lessoncreator.fixes.Fix_Line_Comment_AudioRecordingCommentWithoutNote;
import com.brightworks.lessoncreator.fixes.Fix_Line_Comment_HasAudioRecordingTagButNotAValidAudioRecordingComment;
import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   public class Analyzer_ScriptLine_Comment extends Analyzer_ScriptLine {
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__COMMENT;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__COMMENT;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_Comment(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
      }

      public function extractAudioRecordingNoteFromComment():String {
         if (!isAudioRecordingNoteComment())
            Log.fatal("Analyzer_ScriptLine_Comment.extractAudioRecordingNoteFromComment(): Comment isn't a voice script comment");
         var firstColonIndex:int = lineText.indexOf(":");
         var result:String = lineText.substring(firstColonIndex + 1);
         result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
         return result;
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         var fix:Fix;
         var problem:LessonProblem;
         if ((isIgnoreProblemsComment()) && (getIgnoreProblemsExplanation().length < 2)) {
            fix = new Fix_Line_Comment_IgnoreTagWithoutExplanation(scriptAnalyzer, this);
            problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               '"Ignore" comment without explanation',
               LessonProblem.PROBLEM_TYPE__LINE__COMMENT__IGNORE_TAG_WITHOUT_EXPLANATION,
               LessonProblem.PROBLEM_LEVEL__WORRISOME,
               fix,
               this);
            problemList.push(problem);
         }
         if (isAudioRecordingNoteComment()) {
            if (getLanguageCodeForAudioRecordingNote().length != 3) {
               fix = new Fix_Line_Comment_AudioRecordingCommentWithoutLanguageCode(scriptAnalyzer, this);
               problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  '"Voice talent" comment without language code',
                  LessonProblem.PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__WITHOUT_LANGUAGE_CODE,
                  LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                  fix,
                  this);
               problemList.push(problem);
            } else {
               if (extractAudioRecordingNoteFromComment().length < 2) {
                  fix = new Fix_Line_Comment_AudioRecordingCommentWithoutNote(scriptAnalyzer, this);
                  problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     '"Voice talent" comment without comment',
                     LessonProblem.PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__WITHOUT_NOTE,
                     LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                     fix,
                     this);
                  problemList.push(problem);
               }
            }
         } else {
            if (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE) != -1) {
               fix = new Fix_Line_Comment_HasAudioRecordingTagButNotAValidAudioRecordingComment(scriptAnalyzer, this);
               problem = new LessonProblem(
                     scriptAnalyzer.lessonDevFolder,
                     'Invalid ' + Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE + " comment format.",
                     LessonProblem.PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__INVALID_FORMAT,
                     LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                     fix,
                     this);
               problemList.push(problem);
            }
         }
         return problemList;
      }

      public function isAnnounceChunkComment():Boolean {
         if (lineText.length > (Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__ANNOUNCE_CHUNK.length + 3))
            return false;
         return (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__ANNOUNCE_CHUNK) != -1);
      }

      public function isAudioRecordingNoteCommentForLanguage(iso639_3Code:String):Boolean {
         return (isAudioRecordingNoteComment() && (iso639_3Code == getLanguageCodeForAudioRecordingNote()))
      }

      public function isExplanatoryChunkComment():Boolean {
         if (lineText.length > (Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__EXPLANATORY_CHUNK.length + 3))
            return false;
         return (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__EXPLANATORY_CHUNK) != -1);
      }

      public function isIgnoreProblemsComment():Boolean {
         return (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS) != -1);
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean { // "Comment" lines start with ">>"
         if (lineString.indexOf(">>") == 0)
            return true;
         return false;
      }

      public function isSkipTranslationCheckChunkComment():Boolean {
         return ((lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__SKIP_TRANSLATION_CHECK) == 2) ||
                 (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__SKIP_TRANSLATION_CHECK) == 3));
      }

      public function isVocabularyChunkComment():Boolean {
         return ((lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__VOCABULARY_CHUNK) == 2) ||
         (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__VOCABULARY_CHUNK) == 3));
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      private function getIgnoreProblemsExplanation():String {
         var ignoreProblemsTagIndex:int = lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS);
         if (ignoreProblemsTagIndex == -1)
            Log.fatal("Analyzer_ScriptLine_Comment.getIgnoreProblemsExplanation(): line text doesn't include IGNORE_PROBLEMS_TAG");
         var explanationStartIndex:int = ignoreProblemsTagIndex + Constants_Misc.SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS.length;
         var explanation:String = lineText.substring(explanationStartIndex, lineText.length);
         explanation = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(explanation);
         return explanation;
      }

      private function getLanguageCodeForAudioRecordingNote():String {
         if (!isAudioRecordingNoteComment())
            return "";
         var firstColonIndex:int = lineText.indexOf(":");
         if (firstColonIndex < (Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE.length + 6))
            return "";
         var iso639_3Code:String = lineText.substring(firstColonIndex - 3, firstColonIndex);
         if (!Constants_Language.isStringLanguageCode(iso639_3Code))
            return "";
         return iso639_3Code;
      }

      private function isAudioRecordingNoteComment():Boolean {
         return (lineText.indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE) == 3);
      }

   }
}
















