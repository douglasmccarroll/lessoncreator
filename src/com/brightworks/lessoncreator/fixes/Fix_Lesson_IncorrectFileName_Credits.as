package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.constants.Constants_Misc;
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Utils_File;

    import flash.filesystem.File;

    public class Fix_Lesson_IncorrectFileName_Credits extends Fix {
        public override function get humanReadableFixDescription():String {
            return "Rename file";
        }

        public function Fix_Lesson_IncorrectFileName_Credits() {
            super();
        }

        public override function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
            var existingFile:File = Utils_File.getSingleFileInFolder(lessonDevFolder.getSubfolder_credits());
            var newFile:File = lessonDevFolder.folder.resolvePath(lessonDevFolder.lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_CREDITS_FILE);
            try {
                existingFile.moveTo(newFile);
            } catch (error:Error) {
                return false;
            }
            return newFile.exists;
        }

    }
}
