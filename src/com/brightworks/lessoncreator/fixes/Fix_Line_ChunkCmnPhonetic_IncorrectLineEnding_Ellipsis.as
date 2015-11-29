package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding_Ellipsis extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE__PHONETIC + ". If these lines contain an ellipsis it should be made up of periods (...), rather than being a Chinese ellipsis character (…). This line contains a Chinese ellipsis character.";
        }

        public function Fix_Line_ChunkCmnPhonetic_IncorrectLineEnding_Ellipsis(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
