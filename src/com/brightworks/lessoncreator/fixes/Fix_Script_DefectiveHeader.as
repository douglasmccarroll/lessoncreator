package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Script_DefectiveHeader extends Fix_Script {

        public var lineCount_LinesBeforeFirstBlankLine:uint;

        public override function get humanReadableFixDescription():String {
            return "This script's header has the wrong number of lines. Scripts should start with " + Constants_Misc.LESSON_HEADER__LINE_COUNT + " header lines (not counting comment lines) then a blank line, but in this script there are " + lineCount_LinesBeforeFirstBlankLine + " lines before the first blank line.";
        }

        public function Fix_Script_DefectiveHeader(scriptAnalyzer:Analyzer_Script, lineCount_LinesBeforeFirstBlankLine:uint) {
            super(scriptAnalyzer);
            this.lineCount_LinesBeforeFirstBlankLine = lineCount_LinesBeforeFirstBlankLine;
        }




    }
}
