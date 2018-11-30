package com.brightworks.lessoncreator.fixes {

import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Utils_DataConversionComparison;

public class Fix_Lesson_UnneededOrMisnamedFileOrFiles_Audio extends Fix {

   private var _fileNameList:Array;
   private var _maxFilesToListInProblemDescription:uint;

   public override function get humanReadableFixDescription():String {
      var numberOfFilesToList:uint = Math.min(_fileNameList.length, _maxFilesToListInProblemDescription);
      var result:String = "";
      if (numberOfFilesToList == 1) {
         result += "Unnecessary or incorrectly named audio file - " + _fileNameList[0] + " - Please remove or rename this file.";
      } else {
         result += "Unnecessary or incorrectly named audio files: " + Utils_DataConversionComparison.convertArrayToDelimitedString(_fileNameList, ", ", _maxFilesToListInProblemDescription);
         if (_maxFilesToListInProblemDescription < _fileNameList.length) {
            result += ", plus " + (_fileNameList.length - _maxFilesToListInProblemDescription) + " others. ";
         } else {
            result += ". ";
         }
         result += "Please remove or rename these files."
      }
      return result;
   }

   public function Fix_Lesson_UnneededOrMisnamedFileOrFiles_Audio(fileNameList:Array, maxFilesToListInProblemDescription:uint) {
      _fileNameList = fileNameList;
      _maxFilesToListInProblemDescription = maxFilesToListInProblemDescription;
      super();
   }

   public override function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
      return true;
   }
}
}
