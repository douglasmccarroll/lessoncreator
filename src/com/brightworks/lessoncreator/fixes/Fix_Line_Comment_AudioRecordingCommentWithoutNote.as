package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_Comment_AudioRecordingCommentWithoutNote extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return 'This line says "' + Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE + '" but it does not seem to contain a note.';
        }

        public function Fix_Line_Comment_AudioRecordingCommentWithoutNote(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
