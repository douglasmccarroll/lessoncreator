package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_HeaderEng_Roles_InvalidRoleInfo extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "Based on its position as the 10th line in the script, this line should be the " + Constants_LineType.LINE_TYPE_DESCRIPTION__HEADER__ROLES + ", and should specify '" + Constants_Misc.ROLE_DEFAULT + "' (only) or a list of role names, separated by colons, with no spaces before or after the colons. This line does not do either of these things.";
        }

        public function Fix_Line_HeaderEng_Roles_InvalidRoleInfo(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
