package com.brightworks.lessoncreator.analyzers {
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_NativeLanguage_LanguageCode_IncorrectFormat;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_NativeLanguage_LanguageCode_Unsupported;
import com.brightworks.lessoncreator.fixes.Fix_Line_HeaderEng_NativeLanguage_LinePrefix;
import com.brightworks.lessoncreator.model.MainModel;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_String;

public class Analyzer_ScriptLine_Header_NativeLanguage extends Analyzer_ScriptLine {
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Getters & Setters
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   public static function get lineTypeDescription():String {
      return Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__NATIVE_LANGUAGE;
   }

   public static function get lineTypeId():String {
      return Constants_LineType.LINE_TYPE_ID__HEADER__NATIVE_LANGUAGE;
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Public Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   public function Analyzer_ScriptLine_Header_NativeLanguage(scriptAnalyzer:Analyzer_Script) {
      super(scriptAnalyzer);
      isHeaderLine = true;
   }

   public function getNativeLanguage():String {
      if (lineText.indexOf("Native Language: ") != 0)
         return "";
      var result:String = lineText.substring(17, lineText.length);
      result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(result);
      return result;
   }

   override public function getProblems():Array {
      var problemList:Array = [];
      var fix:Fix;
      var problem:LessonProblem;
      if (lineText.indexOf("Native Language:") != 0) {
         fix = new Fix_Line_HeaderEng_NativeLanguage_LinePrefix(scriptAnalyzer, this);
         problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               "Header native language line missing prefix",
               LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LINE_PREFIX,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               fix,
               this);
         problemList.push(problem);
      }
      var languageCode:String = lineText.substring(16, lineText.length);
      languageCode = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(languageCode);
      if (!((languageCode.length == 3) || (languageCode == "none"))) {
         fix = new Fix_Line_HeaderEng_NativeLanguage_LanguageCode_IncorrectFormat(scriptAnalyzer, this);
         problem = new LessonProblem(
               scriptAnalyzer.lessonDevFolder,
               "Header native language line doesn't specify correct language code",
               LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LANGUAGE_CODE__INCORRECT_FORMAT,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               fix,
               this);
         problemList.push(problem);
      } else {
         if (!MainModel.getInstance().languageConfigInfo.isNativeLanguageSupported(languageCode)) {
            fix = new Fix_Line_HeaderEng_NativeLanguage_LanguageCode_Unsupported(scriptAnalyzer, this);
            Fix_Line_HeaderEng_NativeLanguage_LanguageCode_Unsupported(fix).languageCode = languageCode;
            problem = new LessonProblem(
                  scriptAnalyzer.lessonDevFolder,
                  "Header native language line specifies incorrect or unsupported language code",
                  LessonProblem.PROBLEM_TYPE__LINE__HEADER_ENG__NATIVE_LANGUAGE__LANGUAGE_CODE__UNSUPPORTED,
                  LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
                  fix,
                  this);
            problemList.push(problem);
         }
      }
      return problemList;
   }

   public static function isLineThisType(lineString:String, lineStringList:Array = null, lineNum:int = -1):Boolean {
      // We use another, external, method to determine this at this point, so this method isn't used.
      Log.fatal("Analyzer_ScriptLine_Header_NativeLanguage.isLineThisType(): Method not implemented");
      return false;
   }

}
}

