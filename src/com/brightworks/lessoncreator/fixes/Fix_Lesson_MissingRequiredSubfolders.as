package com.brightworks.lessoncreator.fixes {
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;

import flash.filesystem.File;

public class Fix_Lesson_MissingRequiredSubfolders extends Fix {
   public function Fix_Lesson_MissingRequiredSubfolders() {
      super();
   }

   public override function get humanReadableFixDescription():String {
      return "Create folders";
   }

   public override function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
      var folder:File = lessonDevFolder.folder;
      var missingFolderList:Array = lessonDevFolder.getListOfRequiredLessonDevFolderSubfoldersMissingInFolder();
      var failedFolderCreationList:Array = [];
      for each (var folderName:String in missingFolderList) {
         try {
            folder = folder.resolvePath(folderName);
            folder.createDirectory();
         } catch (error:Error) {
            failedFolderCreationList.push(folderName);
         }
      }
      return (failedFolderCreationList.length == 0);
   }
}
}
