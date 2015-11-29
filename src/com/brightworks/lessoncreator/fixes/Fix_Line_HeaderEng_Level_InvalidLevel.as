package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Line_HeaderEng_Level_InvalidLevel extends Fix_Line {

        public var level:String;

        public override function get humanReadableFixDescription():String {
            return "Level is '" + level + "', which is not a standard level. Please edit this line using one of these levels: Introductory, Beginner, Intermediate, Advanced";
        }

        public function Fix_Line_HeaderEng_Level_InvalidLevel(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, level:String) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.level = level;
        }
    }
}
