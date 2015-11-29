package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script_NoBlankLines extends Fix_Script {

        public override function get humanReadableFixDescription():String {
            return "This lesson's script file doesn't contain any blank lines. You can either create a new script file or edit the existing file so that it conforms to our script format.";
        }

        public function Fix_Script_NoBlankLines(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
        }




    }
}
