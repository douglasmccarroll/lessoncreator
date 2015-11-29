package com.brightworks.lessoncreator.fixes {
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;

import flash.filesystem.File;

    public class Fix_Lesson_MissingRequiredSubfolders extends Fix {
        public override function get humanReadableFixDescription():String {
            return "Create folders";
        }


        public function Fix_Lesson_MissingRequiredSubfolders() {
            super();
        }

        public override function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
            var folder:File = lessonDevFolder.folder;
            var missingFolderList:Array = lessonDevFolder.getListOfRequiredLessonDevFolderSubfoldersMissingInFolder();
            for each (var folderName:String in missingFolderList) {
                /// ToDo What to do about errors/failures?
                folder = folder.resolvePath(folderName);
                folder.createDirectory();
            }
            return true;
        }
    }
}
