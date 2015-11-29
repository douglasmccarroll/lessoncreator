package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
    import com.brightworks.lessoncreator.constants.Constants_LineType;

    public class Fix_Line_RoleEng_InvalidRole extends Fix_Line {

        public var specifiedRole:String;

        public override function get humanReadableFixDescription():String {
            return "This line appears to be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__ROLE_IDENTIFICATION + ", but the role that it names - '" + specifiedRole + "' - isn't listed in the Roles line in the header.";
        }

        public function Fix_Line_RoleEng_InvalidRole(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, specifiedRole:String) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.specifiedRole = specifiedRole;
        }
    }
}
