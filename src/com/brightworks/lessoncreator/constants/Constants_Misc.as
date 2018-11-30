package com.brightworks.lessoncreator.constants {

   public class Constants_Misc {
      public static const APPLICATION_NAME:String = "Lesson Creator";
      public static const BLANK_LINE_INDICATOR:String = "-0-";
      public static const FILE_NAME_BODY__EXPLANATORY_AUDIO:String = "xply";
      public static const FILE_NAME_EXTENSION__AUDIO_FILE__WAV:String = "wav";
      public static const FILE_NAME_EXTENSION__LESSON_BLOG_FILE:String = "blog.txt";
      public static const FILE_NAME_EXTENSION__LESSON_CREDITS_FILE:String = "credits.xml";
      public static const FILE_NAME_EXTENSION__LESSON_SCRIPT_FILE:String = "lmls";
      public static const FILE_NAME_EXTENSION__LESSON_XML_FILE:String = "xml";
      public static const IGNORE_PROBLEMS__USE_COMMENT_FOR_EXCEPTIONS_SENTENCE:String = 'If there is a good reason to make an exception to this rule, please explain it in a "HumanCheck: " comment.';
      public static const LANGCOLLAB_FORUMS_URL:String = "http://www.languagecollaborative.com/index.php/forums";
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__LIST:Array = ["blog", "build", "credits", "script", "wav", "xml"];
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__BLOG:String = "blog";
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__BUILD:String = "build";
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__CREDITS:String = "credits";
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__SCRIPT:String = "script";
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__WAV:String = "wav";
      public static const LESSON_DEV_FOLDER__SUBFOLDER_NAME__XML:String = "xml";
      public static const LESSON_HEADER__LINE_COUNT:uint = 11;
      public static const PUNCTUATION_LIST__NOT_USED_IN_HANZI:Array = [".", ",", "!", "?", "(", ")", "“", "”"];
      public static const ROLE_ALL:String = "All"; // Used when we want to indicate "all roles"
      public static const ROLE_DEFAULT:String = "Default"; // Used when no roles are used in a script
      public static const SCRIPT_COMMENT_TAG__CHUNK__ANNOUNCE_CHUNK:String = "Announce";
      public static const SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE:String = "RecNote";
      public static const SCRIPT_COMMENT_TAG__CHUNK__SKIP_TRANSLATION_CHECK:String = "SkipTranslationCheck";
      public static const SCRIPT_COMMENT_TAG__CHUNK__EXPLANATORY_CHUNK:String = "Explanatory";
      public static const SCRIPT_COMMENT_TAG__CHUNK__VOCABULARY_CHUNK:String = "Vocab";
      public static const SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS:String = "HumanCheck:";
      public static const USER_ACTION_REQUIRED_WAIT_INTERVAL:Number = 400;

      public static function get CHINESE_PUNCTUATION_RULES():String {
         var result:String = "";
         result += "   1. For commas, periods, exclamation marks, question marks and parenthesis, use western-style marks in pinyin lines and hanzi-style marks in hanzi lines.\n";
         result += "   2. For single and double quote marks, use western-style marks in both pinyin and hanzi lines.\n";
         result += "   3. If you use hanzi angle brackets (《   》) in the hanzi line, also use them in the pinyin line.";
         return result;
      }

      public function Constants_Misc() {
      }
   }
}

