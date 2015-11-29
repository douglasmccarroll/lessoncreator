package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script extends Fix {
        protected var scriptAnalyzer:Analyzer_Script;

        public function Fix_Script(scriptAnalyzer:Analyzer_Script) {
            super();
            this.scriptAnalyzer = scriptAnalyzer;
        }
    }
}
