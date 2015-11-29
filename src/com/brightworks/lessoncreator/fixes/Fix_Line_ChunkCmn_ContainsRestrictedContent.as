package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
    import com.brightworks.lessoncreator.constants.Constants_LineType;
    import com.brightworks.lessoncreator.constants.Constants_Misc;
import com.brightworks.lessoncreator.util.contentrestriction.ContentRestriction;

public class Fix_Line_ChunkCmn_ContainsRestrictedContent extends Fix_Line {

        private var _contentRestriction:ContentRestriction;

        public override function get humanReadableFixDescription():String {
            // TODO - implement 'allow content' script comments
            return "This application has been configured to restrict the use of '" + _contentRestriction.restrictedContent + "' in lesson chunks. Either remove this content or override this restriction by preceding the line with a comment that starts with '" + Constants_Misc.SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS + " '.";
        }

        public function Fix_Line_ChunkCmn_ContainsRestrictedContent(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, contentRestriction:ContentRestriction) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            _contentRestriction = contentRestriction;
        }
    }
}
