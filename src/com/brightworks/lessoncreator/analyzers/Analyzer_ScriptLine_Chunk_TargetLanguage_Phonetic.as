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

   public class Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic extends Analyzer_ScriptLine_Chunk {

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

      public function Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
         isChunkLine = true;
      }

      override public function getProblems():Array {
         var problemList:Array = [];
         Log.error("Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic.getProblems(): This method not implemented yet - needs to be written"); // i.e. We aren't currently using this - and perhaps never will - we have a cmn-specific class - and have not yet encountered other needs for phonetic text - and, if we do, the rules will probably be language-specific - so a 'default' class won't be useful?
         return problemList;
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // We use another, external, method to determine this at this point, so this method isn't used.
         Log.fatal("Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic.isLineThisType(): Method not implemented");
         return false;
      }
   }
}
