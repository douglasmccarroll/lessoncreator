package com.brightworks.lessoncreator.problems {
   import com.brightworks.lessoncreator.analyzers.Analyzer;
   import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk;
   import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Script_IndeterminateLineType;
   import com.brightworks.lessoncreator.model.LessonDevFolder;
   import com.brightworks.util.Log;

   import flash.filesystem.File;

   public class LessonProblem {
      public static const PROBLEM_LEVEL__IMPEDIMENT:String = "Impediment";
      public static const PROBLEM_LEVEL__WORRISOME:String = "Worrisome";
      public static const PROBLEM_TYPE__AUDIO__MISSING_FILE_OR_FILES:String = "PROBLEM_TYPE__AUDIO__MISSING_FILE_OR_FILES";
      public static const PROBLEM_TYPE__AUDIO__UNNEEDED_OR_MISNAMED_FILE_OR_FILES:String = "PROBLEM_TYPE__AUDIO__UNNEEDED_OR_MISNAMED_FILE_OR_FILES";
      public static const PROBLEM_TYPE__CHUNK__PUNCTUATION_MISMATCH__ELLIPSIS__TARGET_TO_TARGET_ROMANIZED:String = "PROBLEM_TYPE__CHUNK__PUNCTUATION_MISMATCH__ELLIPSIS__TARGET_TO_TARGET_ROMANIZED";
      public static const PROBLEM_TYPE__CHUNK__PUNCTUATION_MISMATCH__TARGET_TO_TARGET_ROMANIZED:String = "PROBLEM_TYPE__CHUNK__PUNCTUATION_MISMATCH__TARGET_TO_TARGET_ROMANIZED";
      public static const PROBLEM_TYPE__CHUNK__TRANSLATION_PROBLEM:String = "PROBLEM_TYPE__CHUNK__TRANSLATION_PROBLEM";
      public static const PROBLEM_TYPE__INCORRECT_CREDITS_FILE_NAME:String = "PROBLEM_TYPE__INCORRECT_CREDITS_FILE_NAME";
      public static const PROBLEM_TYPE__INCORRECT_SCRIPT_FILE_NAME:String = "PROBLEM_TYPE__INCORRECT_SCRIPT_FILE_NAME";
      public static const PROBLEM_TYPE__INCORRECT_XML_FILE_NAME:String = "PROBLEM_TYPE__INCORRECT_XML_FILE_NAME";
      public static const PROBLEM_TYPE__LINE__CHUNK__CHUNK_TOO_LONG:String = "PROBLEM_TYPE__LINE__CHUNK__CHUNK_TOO_LONG";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__CONTAINS_RESTRICTED_CONTENT:String = "PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__CONTAINS_RESTRICTED_CONTENT";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__FEW_TONE_NUMERALS:String = "PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__FEW_TONE_NUMERALS";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INAPPROPRIATE_CHARACTERS:String = "PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INAPPROPRIATE_CHARACTERS";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING:String = "PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING__ELLIPSIS:String = "PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING__ELLIPSIS";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING__ELLIPSIS_WITHOUT_PRECEDING_SPACE:String = "PROBLEM_TYPE__LINE__CHUNK_CMN_PHONETIC__INCORRECT_LINE_ENDING__ELLIPSIS_WITHOUT_PRECEDING_SPACE";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN__CHUNK_TOO_LONG:String = "PROBLEM_TYPE__LINE__CHUNK_CMN__CHUNK_TOO_LONG";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN__CONTAINS_RESTRICTED_CONTENT:String = "PROBLEM_TYPE__LINE__CHUNK_CMN__CONTAINS_RESTRICTED_CONTENT";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN__INCORRECT_ELLIPSIS:String = "PROBLEM_TYPE__LINE__CHUNK_CMN__INCORRECT_ELLIPSIS";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN__INCORRECT_LINE_ENDING:String = "PROBLEM_TYPE__LINE__CHUNK_CMN__INCORRECT_LINE_ENDING";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN__TOO_FEW_CMN_CHARACTERS:String = "PROBLEM_TYPE__LINE__CHUNK_CMN__TOO_FEW_CMN_CHARACTERS";
      public static const PROBLEM_TYPE__LINE__CHUNK_CMN__WESTERN_STYLE_PUNCTUATION:String = "PROBLEM_TYPE__LINE__CHUNK_CMN__WESTERN_STYLE_PUNCTUATION";
      public static const PROBLEM_TYPE__LINE__CHUNK_ENG__CONTAINS_RESTRICTED_CONTENT:String = "PROBLEM_TYPE__LINE__CHUNK_ENG__CONTAINS_RESTRICTED_CONTENT";
      public static const PROBLEM_TYPE__LINE__CHUNK_ENG__INCORRECT_LINE_ENDING:String = "PROBLEM_TYPE__LINE__CHUNK_ENG__INCORRECT_LINE_ENDING";
      public static const PROBLEM_TYPE__LINE__CHUNK_NOTE_ENG__INCORRECT_LINE_BEGINNING:String = "PROBLEM_TYPE__LINE__CHUNK_NOTE_ENG__INCORRECT_LINE_BEGINNING";
      public static const PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__INVALID_FORMAT:String = "PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__INVALID_FORMAT";
      public static const PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__WITHOUT_LANGUAGE_CODE:String = "PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__WITHOUT_LANGUAGE_CODE";
      public static const PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__WITHOUT_NOTE:String = "PROBLEM_TYPE__LINE__COMMENT__AUDIO_RECORDING_COMMENT__WITHOUT_NOTE";
      public static const PROBLEM_TYPE__LINE__COMMENT__IGNORE_TAG_WITHOUT_EXPLANATION:String = "PROBLEM_TYPE__LINE__COMMENT__IGNORE_TAG_WITHOUT_EXPLANATION";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__AUTHOR_NAME__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__AUTHOR_NAME__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_ID__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_ID__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_NAME__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_NAME__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_SORT_NAME__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__LESSON_SORT_NAME__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__LEVEL__INVALID_LEVEL:String = "PROBLEM_TYPE__LINE__HEADER_ENG__LEVEL__INVALID_LEVEL";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__LEVEL__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__LEVEL__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__LIBRARY_ID__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__LIBRARY_ID__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LANGUAGE_CODE__INCORRECT_FORMAT:String = "PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LANGUAGE_CODE__INCORRECT_FORMAT";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LANGUAGE_CODE__UNSUPPORTED:String = "PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LANGUAGE_CODE__UNSUPPORTED";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__PROVIDER_ID__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__PROVIDER_ID__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__RELEASE_TYPE__INVALID_RELEASE_TYPE:String = "PROBLEM_TYPE__LINE__HEADER_ENG__RELEASE_TYPE__INVALID_RELEASE_TYPE";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__RELEASE_TYPE__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__RELEASE_TYPE__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__ROLES__INVALID_ROLE_INFO:String = "PROBLEM_TYPE__LINE__HEADER_ENG__ROLES__INVALID_ROLE_INFO";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__ROLES__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__ROLES__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__HEADER_ENG__TARGET_LANGUAGE__LINE_PREFIX:String = "PROBLEM_TYPE__LINE__HEADER_ENG__TARGET_LANGUAGE__LINE_PREFIX";
      public static const PROBLEM_TYPE__LINE__ROLE_ENG__INVALID_ROLE:String = "PROBLEM_TYPE__LINE__ROLE_ENG__INVALID_ROLE";
      public static const PROBLEM_TYPE__LINE__ROLE_ENG__NON_STANDARD_COLON:String = "PROBLEM_TYPE__LINE__ROLE_ENG__NON_STANDARD_COLON";
      public static const PROBLEM_TYPE__MISSING_SCRIPT_FILE:String = "PROBLEM_TYPE__MISSING_SCRIPT_FILE";
      public static const PROBLEM_TYPE__MULTIPLE_FILES_IN_CREDITS_FOLDER:String = "PROBLEM_TYPE__MULTIPLE_FILES_IN_CREDITS_FOLDER";
      public static const PROBLEM_TYPE__MULTIPLE_FILES_IN_SCRIPT_FOLDER:String = "PROBLEM_TYPE__MULTIPLE_FILES_IN_SCRIPT_FOLDER";
      public static const PROBLEM_TYPE__MULTIPLE_FILES_IN_XML_FOLDER:String = "PROBLEM_TYPE__MULTIPLE_FILES_IN_XML_FOLDER";
      public static const PROBLEM_TYPE__REQUIRED_SUBFOLDERS_CONTAINING_SUBFOLDERS:String = "PROBLEM_TYPE__REQUIRED_SUBFOLDERS_CONTAINING_SUBFOLDERS";
      public static const PROBLEM_TYPE__REQUIRED_SUBFOLDERS_MISSING_AND_CANNOT_BE_CREATED:String = "PROBLEM_TYPE__REQUIRED_SUBFOLDERS_MISSING_AND_CANNOT_BE_CREATED";
      public static const PROBLEM_TYPE__SCRIPT__INDETERMINATE_LINE_TYPE:String = "PROBLEM_TYPE__SCRIPT__INDETERMINATE_LINE_TYPE";
      public static const PROBLEM_TYPE__SCRIPT__INDETERMINATE_SENTENCE_END__ROMANIZED_TARGET_TEXT:String = "PROBLEM_TYPE__SCRIPT__INDETERMINATE_SENTENCE_END__ROMANIZED_TARGET_TEXT";
      public static const PROBLEM_TYPE__SCRIPT__BLANK_SCRIPT_FILE:String = "PROBLEM_TYPE__SCRIPT__BLANK_SCRIPT_FILE";
      public static const PROBLEM_TYPE__SCRIPT__DEFECTIVE_HEADER:String = "PROBLEM_TYPE__SCRIPT__DEFECTIVE_HEADER";
      public static const PROBLEM_TYPE__SCRIPT__CHUNK_LINES_WITHOUT_ROLE:String = "PROBLEM_TYPE__SCRIPT__CHUNK_LINES_WITHOUT_ROLE";
      public static const PROBLEM_TYPE__SCRIPT__MULTIPLE_COMMENT_LINES_IN_CHUNK_WHICH_SPECIFY_CHUNK_TYPE:String = "PROBLEM_TYPE__SCRIPT__MULTIPLE_COMMENT_LINES_IN_CHUNK_WHICH_SPECIFY_CHUNK_TYPE";
      public static const PROBLEM_TYPE__SCRIPT__SCRIPT_HAS_NO_BLANK_LINES:String = "PROBLEM_TYPE__SCRIPT__SCRIPT_HAS_NO_BLANK_LINES";

      public var humanReadableProblemDescription:String;
      public var problemLevel:String;
      public var problemType:String;

      private var _analyzer:Analyzer;
      private var _fix:Fix;
      private var _folder:LessonDevFolder;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get chunkLineNumber_FirstLine():int {
         if (isScriptChunkSpecificProblem) {
            return Analyzer_ScriptChunk(_analyzer).lineNumber_FirstLine;
         } else {
            Log.error("LessonProblem.get chunkLineNumber_FirstLine(): Problem isn't a chunk-specific problem - check isScriptChunkSpecificProblem before calling this method");
            return -1;
         }
      }

      public function get chunkLineNumber_LastLine():int {
         if (isScriptChunkSpecificProblem) {
            return Analyzer_ScriptChunk(_analyzer).lineNumber_LastLine;
         } else {
            Log.error("LessonProblem.get chunkLineNumber_LastLine(): Problem isn't a chunk-specific problem - check isScriptChunkSpecificProblem before calling this method");
            return -1;
         }
      }

      public function get chunkNumber():int {
         if (isScriptChunkSpecificProblem) {
            return Analyzer_ScriptChunk(_analyzer).chunkNumber;
         } else {
            Log.error("LessonProblem.get chunkNumber(): Problem isn't a chunk-specific problem - check isScriptChunkSpecificProblem before calling this method");
            return -1;
         }
      }

      public function get humanReadableFixDescription():String {
         return _fix.humanReadableFixDescription;
      }

      public function get isScriptChunkSpecificProblem():Boolean {
         return (_analyzer is Analyzer_ScriptChunk);
      }

      public function get isScriptLineSpecificProblem():Boolean {
         if (_analyzer is Analyzer_ScriptLine)
            return true;
         if (problemType == PROBLEM_TYPE__SCRIPT__INDETERMINATE_LINE_TYPE)
            return true;
         return false;
      }

      public function get lineNumber():int {
         if (_analyzer is Analyzer_ScriptLine) {
            return Analyzer_ScriptLine(_analyzer).lineNumber;
         } else if (problemType == PROBLEM_TYPE__SCRIPT__INDETERMINATE_LINE_TYPE) {
            return Fix_Script_IndeterminateLineType(_fix).lineNumber;
         } else {
            Log.error("LessonProblem.get lineNumber(): Problem isn't a line-specific problem - check isScriptLineSpecificProblem before calling this method");
            return -1;
         }
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function LessonProblem(
         folder:LessonDevFolder,
         humanReadableProblemDescription:String,
         problemType:String,
         problemLevel:String,
         fix:Fix = null,
         analyzer:Analyzer = null) {
         _analyzer = analyzer;
         _fix = fix;
         _folder = folder;
         this.humanReadableProblemDescription = humanReadableProblemDescription;
         this.problemLevel = problemLevel;
         this.problemType = problemType;
         if ((_fix) && (_analyzer))
            _fix.analyzer = _analyzer;
      }

      public function fix():void {
         _fix.fix(_folder, this);
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


   }
}
