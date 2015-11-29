package com.brightworks.lessoncreator.analyzers {

   public class Analyzer_ScriptLine_Chunk extends Analyzer_ScriptLine {
      private var chunkAnalyzer:Analyzer_ScriptChunk;

      public function Analyzer_ScriptLine_Chunk(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
      }

      public function getChunkAnalyzer():Analyzer_ScriptChunk {
         return chunkAnalyzer;
      }

      public function isExemptFromPunctuationChecking():Boolean {
         if (chunkAnalyzer.isChunkExemptFromPunctuationChecking())
            return true;
         if (chunkAnalyzer.isLinePrecededByIgnoreProblemsCommentLine(lineTypeId))
            return true;
         return false;
      }

      public function setAnalyzer_ScriptChunk(chunkAnalyzer:Analyzer_ScriptChunk):void {
         this.chunkAnalyzer = chunkAnalyzer;
      }


   }
}
