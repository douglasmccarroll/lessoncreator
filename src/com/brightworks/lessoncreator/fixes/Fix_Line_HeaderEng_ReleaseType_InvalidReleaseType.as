package com.brightworks.lessoncreator.fixes {
import com.brightworks.constant.Constant_ReleaseType;
import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;

    public class Fix_Line_HeaderEng_ReleaseType_InvalidReleaseType extends Fix_Line {

        public var releaseType:String;

        public override function get humanReadableFixDescription():String {
            return "Release Type is '" + releaseType + "', which is not a standard release type. Please edit this line and specify one of the following: " + Constant_ReleaseType.ALPHA_CAPITALIZED + ", " + Constant_ReleaseType.BETA_CAPITALIZED + ", " + Constant_ReleaseType.PRODUCTION_CAPITALIZED;
        }

        public function Fix_Line_HeaderEng_ReleaseType_InvalidReleaseType(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, releaseType:String) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.releaseType = releaseType;
        }
    }
}
