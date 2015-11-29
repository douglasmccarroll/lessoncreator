package com.brightworks.lessoncreator.analyzers {
    import com.brightworks.lessoncreator.constants.Constants_LineType;
    import com.brightworks.util.Utils_String;

    public class Analyzer_ScriptLine_Blank extends Analyzer_ScriptLine {
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Getters & Setters
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public static function get lineTypeDescription():String {
            return Constants_LineType.LINE_TYPE_DESCRIPTION__BLANK;
        }

        public static function get lineTypeId():String {
            return Constants_LineType.LINE_TYPE_ID__BLANK;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine_Blank(scriptAnalyzer:Analyzer_Script) {
            super(scriptAnalyzer);
        }

        override public function getProblems():Array {
            // The "line type" identification phase has already adequately checked this line.
            return [];
        }

        public static function isLineThisType(lineString:String, lineStringList:Array=null, lineNum:int=-1):Boolean {
            var result:Boolean = (Utils_String.removeWhiteSpace(lineString) == "");
            return result;
        }

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Private Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    }
}

