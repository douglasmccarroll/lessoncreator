package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Script_BlankScript extends Fix_Script {

        public override function get humanReadableFixDescription():String {
            return "Script file is empty. Create a new script, or replace the script file with an existing script file.";
        }

        public function Fix_Script_BlankScript(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
        }




    }
}
