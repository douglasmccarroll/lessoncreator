package com.brightworks.lessoncreator.fixes {
    import com.brightworks.lessoncreator.analyzers.Analyzer_ScriptLine;
    import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
import com.brightworks.lessoncreator.constants.Constants_Language;
import com.brightworks.lessoncreator.constants.Constants_Misc;

public class Fix_Line_Comment_AudioRecordingCommentWithoutLanguageCode extends Fix_Line {

        public override function get humanReadableFixDescription():String {
            return 'This line says "' + Constants_Misc.SCRIPT_COMMENT_TAG__CHUNK__AUDIO_RECORDING_NOTE + '" but it does not include a language code followed by a colon. Supported language codes are: ' + Constants_Language.getLanguageCodeListString();
        }

        public function Fix_Line_Comment_AudioRecordingCommentWithoutLanguageCode(scriptAnalyzer:Analyzer_Script, lineTypeAnalyzer:Analyzer_ScriptLine) {
            super(scriptAnalyzer, lineTypeAnalyzer);
        }
    }
}
