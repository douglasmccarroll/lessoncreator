package com.brightworks.lessoncreator.fixes {
   import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.util.translationcheck.TranslationCheck;

   public class Fix_Chunk_TranslationProblem extends Fix_Script {

      public var translationCheck:TranslationCheck;

      public override function get humanReadableFixDescription():String {
         var result:String = translationCheck.humanReadableFixDescription;
         return result;
      }

      public function Fix_Chunk_TranslationProblem(
         scriptAnalyzer:Analyzer_Script,
         translationCheck:TranslationCheck) {
         super(scriptAnalyzer);
         this.translationCheck = translationCheck;
      }




   }
}
