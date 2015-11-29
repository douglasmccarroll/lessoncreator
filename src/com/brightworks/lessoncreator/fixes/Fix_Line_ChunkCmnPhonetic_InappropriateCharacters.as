package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_LineType;

public class Fix_Line_ChunkCmnPhonetic_InappropriateCharacters extends Fix_Line {
        public var toneMarkCharString:String;

        public override function get humanReadableFixDescription():String {
            return "Based on its position in its chunk, this line should be a " + Constants_LineType.LINE_TYPE_DESCRIPTION__CHUNK__TARGET_LANGUAGE__PHONETIC + ". These lines should use numerals to indicate tones, not letters with tone marks. But this line contains these letters: " + toneMarkCharString;
        }

        public function Fix_Line_ChunkCmnPhonetic_InappropriateCharacters(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine, toneMarkCharString:String) {
            super(scriptAnalyzer, lineTypeAnalyzer);
            this.toneMarkCharString = toneMarkCharString;
        }
    }
}
