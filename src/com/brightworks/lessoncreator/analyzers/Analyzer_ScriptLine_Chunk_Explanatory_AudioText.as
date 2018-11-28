package com.brightworks.lessoncreator.analyzers {
   import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.util.Log;

   public class Analyzer_ScriptLine_Chunk_Explanatory_AudioText extends Analyzer_ScriptLine_Chunk {
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public static function get lineTypeDescription():String {
         return Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__EXPLANATORY__AUDIO_TEXT;
      }

      public static function get lineTypeId():String {
         return Constants_LineType.LINE_TYPE_ID__CHUNK__EXPLANATORY__AUDIO_TEXT;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptLine_Chunk_Explanatory_AudioText(scriptAnalyzer:Analyzer_Script) {
         super(scriptAnalyzer);
         isChunkLine = true;
      }

      override public function getProblems():Array {
         return [];
      }

      public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
         // We use another, external, method to determine this at this point, so this method isn't used.
         Log.fatal("Analyzer_ScriptLine_Chunk_Explanatory_AudioText.isLineThisType(): Method not implemented");
         return false;
      }

   }
}
