package com.brightworks.lessoncreator.analyzers
{
    import com.brightworks.util.Log;

    public class Analyzer_ScriptLine extends Analyzer
    {
        public var isChunkLine:Boolean;
        public var isHeaderLine:Boolean;
        public var lineNumber:uint;
        public var lineText:String;
        public var lineTypeId:String;
        public var roleName:String;

        protected var scriptAnalyzer:Analyzer_Script;

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        public function Analyzer_ScriptLine(scriptAnalyzer:Analyzer_Script) {
            this.scriptAnalyzer = scriptAnalyzer;
        }

        public function getProblems():Array
        {
            Log.fatal("Analyzer_ScriptLine.getProblems(): Abstract method - should never be called");
            return [];
        }

    }
}

