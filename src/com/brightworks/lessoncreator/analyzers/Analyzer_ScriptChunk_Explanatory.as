package com.brightworks.lessoncreator.analyzers {
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Analyzer_ScriptChunk_Explanatory extends Analyzer_ScriptChunk {


      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptChunk_Explanatory(scriptAnalyzer:Analyzer_Script) {
         chunkType = Analyzer_ScriptChunk.CHUNK_TYPE__EXPLANATORY;
         super(scriptAnalyzer);
      }

   public function getLineText_Audio():String {
      return getLineText(Constants_LineType.LINE_TYPE_ID__CHUNK__EXPLANATORY__AUDIO_TEXT);
   }

   public function getLineText_Display():String {
      return getLineText(Constants_LineType.LINE_TYPE_ID__CHUNK__EXPLANATORY__DISPLAY_TEXT);
   }

   public override function isChunkExemptFromPunctuationChecking():Boolean {
         return true;
      }

      public override function isChunkExemptFromTranslationCheck():Boolean {
         return true;
      }


   }
}








