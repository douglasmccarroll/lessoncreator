package com.brightworks.lessoncreator.analyzers {

   public class Analyzer_ScriptLine_Chunk extends Analyzer_ScriptLine {
      private var _chunkAnalyzer:Analyzer_ScriptChunk;

      public function Analyzer_ScriptLine_Chunk(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
      }

      public function getChunkAnalyzer():Analyzer_ScriptChunk {
         return _chunkAnalyzer;
      }

      public function isExemptFromPunctuationChecking():Boolean {
         if (_chunkAnalyzer.isChunkExemptFromPunctuationChecking())
            return true;
         if (_chunkAnalyzer.isLinePrecededByIgnoreProblemsCommentLine(lineTypeId))
            return true;
         return false;
      }

      public function setAnalyzer_ScriptChunk(chunkAnalyzer:Analyzer_ScriptChunk):void {
         this._chunkAnalyzer = chunkAnalyzer;
      }


   }
}
