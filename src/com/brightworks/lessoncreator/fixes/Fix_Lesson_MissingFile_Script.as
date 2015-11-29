package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.constants.Constants_Misc;
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
    import com.brightworks.util.Utils_File;

    import flash.filesystem.File;

    public class Fix_Lesson_MissingFile_Script extends Fix {
        public override function get humanReadableFixDescription():String {
            return "Create file";
        }

        public function Fix_Lesson_MissingFile_Script() {
            super();
        }

        public override function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
            var folder:File = lessonDevFolder.getSubfolder_script();
            var file:File = folder.resolvePath(lessonDevFolder.lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_SCRIPT_FILE);
            if (file.exists) {
                Log.error("Fix_Lesson_MissingFile_Script.fix(): File already exists")
            }
            var success:Boolean = Utils_File.createEmptyFile(file, false);
            return true;
        }
    }
}
