package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Line extends Fix {
        protected var lineTypeAnalyzer:Analyzer_ScriptLine;
        protected var scriptAnalyzer:Analyzer_Script;

        public function Fix_Line(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super();
            this.lineTypeAnalyzer = lineTypeAnalyzer;
            this.scriptAnalyzer = scriptAnalyzer;
        }
    }
}
