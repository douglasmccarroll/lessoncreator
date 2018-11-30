package com.brightworks.lessoncreator.analyzers {
import com.brightworks.constant.Constant_ReleaseType;
import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.constants.Constants_Punctuation;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Chunk_PunctuationMismatch_Ellipsis_TargetToTargetPhonetic;
   import com.brightworks.lessoncreator.fixes.Fix_Chunk_PunctuationMismatch_TargetToTargetPhonetic;
import com.brightworks.lessoncreator.fixes.Fix_Chunk_TranslationProblem;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.lessoncreator.util.translationcheck.TranslationCheck;
import com.brightworks.lessoncreator.util.translationcheck.TranslationCheckProcessor;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_DataConversionComparison;
import com.brightworks.util.Utils_String;

   import flash.utils.Dictionary;

   public class Analyzer_ScriptChunk extends Analyzer {

      public static const CHUNK_TYPE__DEFAULT:String =  "CHUNK_TYPE__DEFAULT";
      public static const CHUNK_TYPE__EXPLANATORY:String =  "CHUNK_TYPE__EXPLANATORY";
      public static const CHUNK_TYPE__UNKNOWN:String =  "CHUNK_TYPE__UNKNOWN";

      public var chunkNumber:int;
      public var chunkType:String;  // One of the constants defined above
      public var lineAnalyzerListIncludingCommentLines:Array;
      public var lineCode:String;
      public var roleName:String;

      protected var lineInfoList:Dictionary; // Properties are chunk line type ID constants (defined in Constants_LineType), values are Analyzer_ScriptLine instances
      protected var scriptAnalyzer:Analyzer_Script;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get chunkNumberString():String {
         return Utils_DataConversionComparison.convertNumberToString(chunkNumber, 0, true, 2, "0");
      }

      public function get lineNumber_FirstLine():uint {
         var lineAnalyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[0];
         return lineAnalyzer.lineNumber;
      }

      public function get lineNumber_LastLine():uint {
         var lineAnalyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[lineAnalyzerListIncludingCommentLines.length - 1];
         return lineAnalyzer.lineNumber;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptChunk(scriptAnalyzer:Analyzer_Script) {
         this.scriptAnalyzer = scriptAnalyzer;
         lineInfoList = new Dictionary();
      }

      public function addAnalyzer_ScriptLine(analyzer:Analyzer_ScriptLine):void {
         // We assume that all chunk types will only have one instance of any type of script line. At present this is true, but if it changes
         // we'll need to add this method to one or more subclasses.
         if (lineInfoList.hasOwnProperty(analyzer.lineTypeId))
            Log.fatal("Analyzer_ScriptChunk.addAnalyzer_ScriptLine(): Line analyzer of type '" + analyzer.lineTypeId + "' has already been added to this chunk");
         lineInfoList[analyzer.lineTypeId] = analyzer;
      }

      public function getAnalyzer_ScriptLine(lineType:String):Analyzer_ScriptLine {
         // We assume that all chunk types will only have one instance of any type of script line. At present this is true, but if it changes
         // we'll need to add this method to one or more subclasses.
         if (!lineInfoList)
            throw new Error("Analyzer_ScriptChunk.getAnalyzer_ScriptLine(): lineInfoList is null");
         if (!lineInfoList.hasOwnProperty(lineType))
            return null;   // This is usually the case when the line-type is 'note'
         var result:Analyzer_ScriptLine = lineInfoList[lineType];
         return result;
      }

      public function addAudioFileNamesToList(list:Array):void {
         Log.fatal("Analyzer_ScriptChunk.addAudioFileNamesToList() - Abstract method - should only be called in subclasses");
         return;
      }

      public function getLineNumber(lineType:String):uint {
         // We assume that all chunk types will only have one instance of any type of script line. At present this is true, but if it changes
         // we'll need to add this method to one or more subclasses.
         var la:Analyzer_ScriptLine = getAnalyzer_ScriptLine(lineType);
         var result:int = la.lineNumber;
         return result;
      }

      public function getLineText(lineType:String):String {
         var la:Analyzer_ScriptLine = getAnalyzer_ScriptLine(lineType);
         var result:String;
         if (la)
               result = la.lineText
         return result;
      }

      public function getLineText_Note():String {
         return getLineText(Constants_LineType.LINE_TYPE_ID__CHUNK__NOTE);
      }

      public function getLineTextCharCount(lineType:String):int {
         var result:int = getLineText(lineType).length;
         return result;
      }

      public function getLineTypeName(lineType:String):String {
         var la:Analyzer_ScriptLine = getAnalyzer_ScriptLine(lineType);
         var result:String = la.lineTypeId;
         return result;
      }

      public function getProblems():Array {
         return [];
      }

      public function isChunkExemptFromPunctuationChecking():Boolean {
         Log.fatal("Analyzer_ScriptChunk.isChunkExemptFromPunctuationChecking() - Abstract method - should only be called in subclasses");
         return true;
      }

      public function isChunkExemptFromTranslationCheck():Boolean {
         Log.fatal("Analyzer_ScriptChunk.isChunkExemptFromPunctuationChecking() - Abstract method - should only be called in subclasses");
         return true;
      }

      public function isLinePrecededByIgnoreProblemsCommentLine(lineType:String):Boolean {
         var indexOfLine:int = getIndexOfLineInLineAnalyzerListIncludingCommentLines(lineType);
         if (indexOfLine == 0)
            return false;
         var precedingAnalyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[indexOfLine - 1];
         var result:Boolean = false;
         if (precedingAnalyzer.lineTypeId == Constants_LineType.LINE_TYPE_ID__COMMENT) {
            if (Analyzer_ScriptLine_Comment(precedingAnalyzer).isIgnoreProblemsComment())
               result = true;
         }
         return result;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Protected Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      protected function getIndexOfLineInLineAnalyzerListIncludingCommentLines(lineType:String):int {
         var result:int = -1;
         for (var i:int = 0; i < lineAnalyzerListIncludingCommentLines.length; i++) {
            var analyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[i];
            if (analyzer.lineTypeId == lineType) {
               result = i;
               break;
            }
         }
         if (result == -1)
            Log.fatal("Analyzer_ScriptChunk.getIndexOfLineInLineAnalyzerListIncludingCommentLines(): no line analyzer of that type is in list");
         return result;
      }

   }
}








