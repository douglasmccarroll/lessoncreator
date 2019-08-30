package com.brightworks.lessoncreator.model {

import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk_Default;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk_Explanatory;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_String;

public class BlogTextCreator {

   public function BlogTextCreator(lessonDevFolder:LessonDevFolder) {
      _lessonDevFolder = lessonDevFolder;
      _scriptAnalyzer = lessonDevFolder.scriptAnalyzer;
   }
   private var _lessonDevFolder:LessonDevFolder;
   private var _scriptAnalyzer:Analyzer_Script;

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //     Public Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   public function get blogText():String {
      return createBlogText();
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //     Private Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   private function createBlogText():String {
      var result:String = "";
      result += _lessonDevFolder.lessonName + "\n";
      result += _lessonDevFolder.level + "\n\n";
      var currChunkRoleName:String;
      for (var chunkNum:uint = 1; chunkNum <= _scriptAnalyzer.chunkCount; chunkNum++) {
         var chunkAnalyzer:Analyzer_ScriptChunk = _scriptAnalyzer.getChunkAnalyzer(chunkNum);
         if (currChunkRoleName != chunkAnalyzer.roleName) {
            currChunkRoleName = chunkAnalyzer.roleName;
            result += chunkAnalyzer.roleName + ":\n \n";     // We include a space here because some blog platforms interpret a lone "\n" as a paragraph break, and we want a simple blank line
         }
         result += createScriptText_Chunk(chunkAnalyzer);
      }
      return result;
   }

   private function createScriptText_Chunk(chunkAnalyzer:Analyzer_ScriptChunk):String {
      var result:String = "";
      switch (chunkAnalyzer.chunkType) {
         case Analyzer_ScriptChunk.CHUNK_TYPE__DEFAULT: {
            var text_Chunk_Native:String = Analyzer_ScriptChunk_Default(chunkAnalyzer).getLineText_Native();
            var text_Chunk_Target:String = Analyzer_ScriptChunk_Default(chunkAnalyzer).getLineText_Target();
            var text_Chunk_TargetPhonetic:String = Analyzer_ScriptChunk_Default(chunkAnalyzer).getLineText_TargetPhonetic();
            if (text_Chunk_Native) {  ///// kludge - the chunk analyzer should know if/when this is a single language lesson?
               text_Chunk_Native = Utils_String.replaceAll(text_Chunk_Native, "-0-", "");
               result += text_Chunk_Native + "\n";
            }
            if (MainModel.getInstance().languageConfigInfo.doesLanguageRequireUseOfPhoneticTargetLanguageLineInScript(_lessonDevFolder.targetLanguageISO639_3Code)) {
               text_Chunk_TargetPhonetic = Utils_String.replaceAll(text_Chunk_TargetPhonetic, "-0-", "");
               result += text_Chunk_TargetPhonetic + "\n";
            }
            text_Chunk_Target = Utils_String.replaceAll(text_Chunk_Target, "-0-", "");
            result += text_Chunk_Target + "\n";
            break;
         }
         case Analyzer_ScriptChunk.CHUNK_TYPE__EXPLANATORY: {
            var text_Chunk_Display:String = Analyzer_ScriptChunk_Explanatory(chunkAnalyzer).getLineText_Display();
            var text_Chunk_Audio:String = Analyzer_ScriptChunk_Explanatory(chunkAnalyzer).getLineText_Audio();
            result += text_Chunk_Display + "\n" + text_Chunk_Audio + "\n";
            break;
         }
         default:
            Log.error("BlogTextCreator.createScriptText_Chunk() - No case for chunk type of: " + chunkAnalyzer.chunkType);
      }
      var text_Chunk_Note:String = chunkAnalyzer.getLineText_Note();
      if (text_Chunk_Note)
            result += text_Chunk_Note + "\n";
      result += " \n";  // We include a space here because some blog platforms interpret a lone "\n" as a paragraph break, and we want a simple blank line
      return result;
   }




}
}




















