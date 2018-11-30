package com.brightworks.lessoncreator.fixes {

import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Utils_DataConversionComparison;

public class Fix_Lesson_MissingFileOrFiles_Audio extends Fix {

   private var _fileNameList:Array;
   private var _maxFilesToListInProblemDescription:uint;

   public override function get humanReadableFixDescription():String {
      var numberOfFilesToList:uint = Math.min(_fileNameList.length, _maxFilesToListInProblemDescription);
      var result:String = "";
      if (numberOfFilesToList == 1) {
         result += "Missing audio file: " + _fileNameList[0];
      } else {
         result += "Missing audio files: " + Utils_DataConversionComparison.convertArrayToDelimitedString(_fileNameList, ", ", _maxFilesToListInProblemDescription);
         if (_maxFilesToListInProblemDescription < _fileNameList.length) {
            result += ", plus " + (_fileNameList.length - _maxFilesToListInProblemDescription) + " others.";
         } else {
            result += ".";
         }
      }
      return result;
   }

   public function Fix_Lesson_MissingFileOrFiles_Audio(fileNameList:Array, maxFilesToListInProblemDescription:uint) {
      _fileNameList = fileNameList;
      _maxFilesToListInProblemDescription = maxFilesToListInProblemDescription;
      super();
   }

   public override function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
      return true;
   }
}
}
