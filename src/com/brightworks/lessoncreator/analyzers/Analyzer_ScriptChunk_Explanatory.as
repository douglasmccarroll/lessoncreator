package com.brightworks.lessoncreator.analyzers {
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;

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

      public override function addAudioFileNamesToList(list:Array):void {
         list.push(chunkNumberString + "." + Constants_Misc.FILE_NAME_BODY__EXPLANATORY_AUDIO + "." + Constants_Misc.FILE_NAME_EXTENSION__AUDIO_FILE__WAV);
         return;
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








