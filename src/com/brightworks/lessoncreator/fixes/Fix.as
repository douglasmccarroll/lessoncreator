package com.brightworks.lessoncreator.fixes {
import com.brightworks.lessoncreator.analyzers.Analyzer;
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;

    public class Fix {

        public var analyzer:Analyzer;

        public function get humanReadableFixDescription():String {
            Log.error("Fix.get humanReadableFixDescription(): Abstract method - should never be called");
            return "";
        }

        public function Fix() {
        }

        public function fix(lessonDevFolder:LessonDevFolder, lessonProblem:LessonProblem):Boolean {
            // Some subclasses will implement this. In other subclasses it simply won't be used. In other words, some
            // subclasses are capable of fixing their problem, others aren't. In the latter case, they provide sufficient
            // information to the code that uses them to allow that code to help the user fix the problem.
            Log.error("Fix.fix(): Abstract method - should never be called");
            return false;
        }
    }


}
