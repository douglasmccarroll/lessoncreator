package com.brightworks.lessoncreator.model {

import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptChunk;
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
            result += chunkAnalyzer.roleName + ":\n\n";
         }
         result += createScriptText_Chunk(chunkAnalyzer);
      }
      return result;
   }

   private function createScriptText_Chunk(chunkAnalyzer:Analyzer_ScriptChunk):String {
      var result:String = "";
      var text_Chunk_Native:String = chunkAnalyzer.getLineText_Native();
      var text_Chunk_Target:String = chunkAnalyzer.getLineText_Target();
      var text_Chunk_TargetPhonetic:String = chunkAnalyzer.getLineText_TargetPhonetic();
      var text_Chunk_Note:String = chunkAnalyzer.getLineText_Note();
      text_Chunk_Native = Utils_String.replaceAll(text_Chunk_Native, "-0-", "");
      text_Chunk_Target = Utils_String.replaceAll(text_Chunk_Target, "-0-", "");
      text_Chunk_TargetPhonetic = Utils_String.replaceAll(text_Chunk_TargetPhonetic, "-0-", "");
      result += text_Chunk_Native + "\n";
      result += text_Chunk_TargetPhonetic + "\n";
      result += text_Chunk_Target + "\n";
      if (text_Chunk_Note)
            result += text_Chunk_Note + "\n";
      result += " \n";  // We include a space here because some blog platforms interpret a lone "\n" as a paragraph break, and we want a simple blank line
      return result;
   }




}
}




















