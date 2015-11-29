package com.brightworks.lessoncreator.analyzers {
import com.brightworks.constant.Constant_ReleaseType;
import com.brightworks.lessoncreator.constants.Constants_LineType;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.constants.Constants_Punctuation;
   import com.brightworks.lessoncreator.fixes.Fix;
   import com.brightworks.lessoncreator.fixes.Fix_Chunk_PunctuationMismatch_Ellipsis_TargetToTargetPhonetic;
   import com.brightworks.lessoncreator.fixes.Fix_Chunk_PunctuationMismatch_TargetToTargetPhonetic;
import com.brightworks.lessoncreator.fixes.Fix_Chunk_TranslationProblem;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.lessoncreator.util.translationcheck.TranslationCheck;
import com.brightworks.lessoncreator.util.translationcheck.TranslationCheckProcessor;
import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;

   import flash.utils.Dictionary;

   public class Analyzer_ScriptChunk extends Analyzer {
      public var chunkNumber:int;
      public var lineAnalyzerListIncludingCommentLines:Array;
      public var lineCode:String;
      public var nativeLanguageIso639_3Code:String;
      public var roleName:String;
      public var targetLanguageIso639_3Code:String;

      private var _lineInfoList:Dictionary; // Properties are chunk line type ID constants (defined in Constants_LineType), values are Analyzer_ScriptLine instances
      private var _scriptAnalyzer:Analyzer_Script;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
      //
      //          Getters & Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

      public function get lineNumber_FirstLine():uint {
         var lineAnalyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[0];
         return lineAnalyzer.lineNumber;
      }

      public function get lineNumber_LastLine():uint {
         var lineAnalyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[lineAnalyzerListIncludingCommentLines.length - 1];
         return lineAnalyzer.lineNumber;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      public function Analyzer_ScriptChunk(scriptAnalyzer:Analyzer_Script) {
         _scriptAnalyzer = scriptAnalyzer;
         _lineInfoList = new Dictionary();
      }

      public function addAnalyzer_ScriptLine(analyzer:Analyzer_ScriptLine):void {
         if (_lineInfoList.hasOwnProperty(analyzer.lineTypeId))
            Log.fatal("Analyzer_ScriptChunk.addAnalyzer_ScriptLine(): Line analyzer of type '" + analyzer.lineTypeId + "' has already been added to this chunk");
         _lineInfoList[analyzer.lineTypeId] = analyzer;
      }

      public function getAnalyzer_ScriptLine(lineType:String):Analyzer_ScriptLine {
         if (!_lineInfoList)
            throw new Error("Analyzer_ScriptChunk.getAnalyzer_ScriptLine(): _lineInfoList is null");
         if (!_lineInfoList.hasOwnProperty(lineType))
            throw new Error("Analyzer_ScriptChunk.getAnalyzer_ScriptLine(): _lineInfoList has no " + lineType + " property");
         var result:Analyzer_ScriptLine = _lineInfoList[lineType];
         return result;
      }

      public function getAudioRecordingNotesForLanguage(iso639_3Code:String):Array {
         var result:Array = [];
         for each (var a:Analyzer_ScriptLine in lineAnalyzerListIncludingCommentLines) {
            if (!(a is Analyzer_ScriptLine_Comment))
               continue;
            if (Analyzer_ScriptLine_Comment(a).isAudioRecordingNoteCommentForLanguage(iso639_3Code))
               result.push(Analyzer_ScriptLine_Comment(a).extractAudioRecordingNoteFromComment());
         }
         return result;
      }

      public function getAudioRecordingNotesForLanguage_Native():Array {
         return getAudioRecordingNotesForLanguage(nativeLanguageIso639_3Code);
      }

      public function getAudioRecordingNotesForLanguage_Target():Array {
         return getAudioRecordingNotesForLanguage(targetLanguageIso639_3Code);
      }

      public function getLineNumber(lineType:String):uint {
         var la:Analyzer_ScriptLine = getAnalyzer_ScriptLine(lineType);
         var result:int = la.lineNumber;
         return result;
      }

      public function getLineText(lineType:String):String {
         var la:Analyzer_ScriptLine = getAnalyzer_ScriptLine(lineType);
         var result:String = la.lineText;
         return result;
      }

      public function getLineText_Native():String {
         return getLineText(Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE);
      }

      public function getLineText_Target():String {
         return getLineText(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
      }

      public function getLineText_TargetPhonetic():String {
         return getLineText(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
      }

      public function getLineTextCharCount(lineType:String):int {
         var result:int = getLineText(lineType).length;
         return result;
      }

      public function getLineTextWordCount(lineType:String):int {
         if (lineType != Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE)
            Log.fatal("Analyzer_ScriptChunk.getLineTextWordCount(): Method is currently only implemented for LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE, i.e., at present, English.");
         var result:int = Utils_String.getWordCountForString(getLineText(lineType));
         return result;
      }

      public function getLineTypeName(lineType:String):String {
         var la:Analyzer_ScriptLine = getAnalyzer_ScriptLine(lineType);
         var result:String = la.lineTypeId;
         return result;
      }

      public function getProblems():Array {
         var problemList:Array = [];
         if (!isChunkExemptFromPunctuationChecking()) {
            checkForPunctuationMismatchesBetweenHanziAndPinyinLines(problemList);
            checkEllipses(problemList);
         }
         checkTranslations(problemList);
         return problemList;
      }

      public function isAnnounceChunk():Boolean {
         var result:Boolean = false;
         for each (var a:Analyzer_ScriptLine in lineAnalyzerListIncludingCommentLines) {
            if (!(a is Analyzer_ScriptLine_Comment))
               continue;
            if (Analyzer_ScriptLine_Comment(a).isAnnounceChunkComment()) {
               result = true;
               break;
            }
         }
         return result;
      }

      public function isChunkExemptFromPunctuationChecking():Boolean {
         if (_scriptAnalyzer.releaseType != Constant_ReleaseType.ALPHA_CAPITALIZED)
            return true;
         var foo:int;
         return (isAnnounceChunk() || isVocabularyChunk());
      }

      public function isChunkExemptFromTranslationCheck():Boolean {
         if (_scriptAnalyzer.releaseType != Constant_ReleaseType.ALPHA_CAPITALIZED)
            return true;
         var result:Boolean = false;
         for each (var a:Analyzer_ScriptLine in lineAnalyzerListIncludingCommentLines) {
            if (!(a is Analyzer_ScriptLine_Comment))
               continue;
            if (Analyzer_ScriptLine_Comment(a).isSkipTranslationCheckChunkComment()) {
               result = true;
               break;
            }
         }
         return result;
      }

      public function isLinePrecededByIgnoreProblemsCommentLine(lineType:String):Boolean {
         var indexOfLine:int = getIndexOfLineInLineAnalyzerListIncludingCommentLines(lineType);
         if (indexOfLine == 0)
            return false;
         var precedingAnalyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[indexOfLine - 1];
         var result:Boolean = false;
         if (precedingAnalyzer.lineTypeId == Constants_LineType.LINE_TYPE_ID__COMMENT) {
            if (Analyzer_ScriptLine_Comment(precedingAnalyzer).isIgnoreProblemsComment())
               result = true;
         }
         return result;
      }

      public function isPinyinLineFinalOrOnlyChunkInSentence():Boolean {
         var pinyinLineText:String = getLineText_TargetPhonetic();
         var result:Boolean = false;
         if (!Utils_String.doesStringEndWithString(pinyinLineText, "...")) {
            if (Utils_String.doesStringEndWithString(pinyinLineText, [".", "?", "!"]))
               result = true;
         }
         return result;
      }

      public function isPinyinLineFirstOrOnlyChunkInSentence():Boolean {
         var pinyinLineText:String = getLineText_TargetPhonetic();
         var firstNonQuoteChar:String = Utils_String.getFirstCharInStringThatIsNotOtherSpecifiedChars(pinyinLineText, Constants_Punctuation.QUOTATION_MARKS__DOUBLE);
         var result:Boolean = Utils_String.isCharUpperCase(firstNonQuoteChar);
         return result;
      }

      public function isVocabularyChunk():Boolean {
         var result:Boolean = false;
         for each (var a:Analyzer_ScriptLine in lineAnalyzerListIncludingCommentLines) {
            if (!(a is Analyzer_ScriptLine_Comment))
               continue;
            if (Analyzer_ScriptLine_Comment(a).isVocabularyChunkComment()) {
               result = true;
               break;
            }
         }
         return result;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //          Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

      /**
       *
       * @param problemList
       *
       */
      private function checkEllipses(problemList:Array):void {
         var bIgnoreHanziLine:Boolean = isLinePrecededByIgnoreProblemsCommentLine(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
         var bIgnorePinyinLine:Boolean = isLinePrecededByIgnoreProblemsCommentLine(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
         if (bIgnoreHanziLine && bIgnorePinyinLine)
            return;
         var hanziLineText:String = getLineText_Target();
         var pinyinLineText:String = getLineText_TargetPhonetic();
         var bHanziLineEllipsis:Boolean = Utils_String.doesStringEndWithString(hanziLineText, "……");
         var bPinyinLineEllipsis:Boolean = Utils_String.doesStringEndWithString(pinyinLineText, "...");
         if ((bHanziLineEllipsis && !bPinyinLineEllipsis) || (!bHanziLineEllipsis && bPinyinLineEllipsis)) {
            var hanziLineNumber:int = getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
            var pinyinLineNumber:int = getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
            var fix:Fix = new Fix_Chunk_PunctuationMismatch_Ellipsis_TargetToTargetPhonetic(_scriptAnalyzer, hanziLineNumber, pinyinLineNumber);
            var problem:LessonProblem = new LessonProblem(
               _scriptAnalyzer.lessonDevFolder,
               _scriptAnalyzer.getChunkLineStyleName_Target(true) + " and " + _scriptAnalyzer.getChunkLineStyleName_TargetRomanized(false) + " punctuation don't correspond",
               LessonProblem.PROBLEM_TYPE__CHUNK__PUNCTUATION_MISMATCH__ELLIPSIS__TARGET_TO_TARGET_ROMANIZED,
               LessonProblem.PROBLEM_LEVEL__WORRISOME,
               fix,
               this);
            problemList.push(problem);
         }
      }

      private function checkForPunctuationMismatchesBetweenHanziAndPinyinLines(problemList:Array):void {
         var bIgnoreHanziLine:Boolean = isLinePrecededByIgnoreProblemsCommentLine(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
         if (bIgnoreHanziLine)
            return;
         var hanziLineText:String = getLineText_Target();
         var pinyinLineText:String = getLineText_TargetPhonetic();
         var hanziPunctuationString:String = extractHanziLinePunctuationMarks(hanziLineText);
         var pinyinPunctuationString:String = extractPinyinLinePunctuationMarks(pinyinLineText);
         var bProblem:Boolean = false;
         var hanziChar:String;
         var pinyinChar:String;
         if (hanziPunctuationString.length != pinyinPunctuationString.length) {
            bProblem = true;
         } else {
            var charCount:int = hanziPunctuationString.length;
            for (var charIndex:int = 0; charIndex < charCount; charIndex++) {
               hanziChar = hanziPunctuationString.charAt(charIndex);
               pinyinChar = pinyinPunctuationString.charAt(charIndex);
               if (!doesHanziPunctuationMarkMatchPinyinPunctuationMark(hanziChar, pinyinChar)) {
                  bProblem = true;
                  break;
               }
            }
         }
         if (bProblem) {
            var hanziLineNumber:int = getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE);
            var pinyinLineNumber:int = getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
            var combinedPunctuationStringForHanzi:String = extractCombinedPunctuationStringFromLine(hanziLineText);
            var combinedPunctuationStringForPinyin:String = extractCombinedPunctuationStringFromLine(pinyinLineText);
            var fix:Fix = new Fix_Chunk_PunctuationMismatch_TargetToTargetPhonetic(_scriptAnalyzer, hanziLineNumber, pinyinLineNumber, combinedPunctuationStringForHanzi, combinedPunctuationStringForPinyin);
            var problem:LessonProblem = new LessonProblem(
               _scriptAnalyzer.lessonDevFolder,
               _scriptAnalyzer.getChunkLineStyleName_Target(true) + " and " + _scriptAnalyzer.getChunkLineStyleName_TargetRomanized(false) + " punctuation don't correspond",
               LessonProblem.PROBLEM_TYPE__CHUNK__PUNCTUATION_MISMATCH__TARGET_TO_TARGET_ROMANIZED,
               LessonProblem.PROBLEM_LEVEL__WORRISOME,
               fix,
               this);
            problemList.push(problem);
         }
      }

      private function checkTranslations(problemList:Array):void {
         if (isChunkExemptFromTranslationCheck())
            return;
         var problematicTranslationCheckList:Array = TranslationCheckProcessor.getListOfFailedTranslationChecks(this);
         for each (var check:TranslationCheck in problematicTranslationCheckList) {
            var fix:Fix = new Fix_Chunk_TranslationProblem(_scriptAnalyzer, check);
            var problem:LessonProblem = new LessonProblem(
                  _scriptAnalyzer.lessonDevFolder,
                  "Translation problem",
                  LessonProblem.PROBLEM_TYPE__CHUNK__TRANSLATION_PROBLEM,
                  LessonProblem.PROBLEM_LEVEL__WORRISOME,
                  fix,
                  this);
            problemList.push(problem);

         }
      }
      private function doesHanziPunctuationMarkMatchPinyinPunctuationMark(hanziMark:String, pinyinMark:String):Boolean {
         return doesPunctuationMarkMatchPunctuationMark(hanziMark, pinyinMark, (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.hanziPunctuation as Array), (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.pinyinPunctuation as Array));
      }

      private function doesPinyinPunctuationMarkMatchHanziPunctuationMark(pinyinMark:String, hanziMark:String):Boolean {
         return doesPunctuationMarkMatchPunctuationMark(pinyinMark, hanziMark, (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.pinyinPunctuation as Array), (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.hanziPunctuation as Array));
      }

      private function doesPunctuationMarkMatchPunctuationMark(markToMatch:String, possibleMatch:String, markToMatchList:Array, possibleMatchList:Array):Boolean {
         // markToMatchList is an array containing the markToMatch. We use it to get 
         // the position of the mark in the list. The possibleMatchList contains
         // marks that are the cross-language equivalent of the marks in the
         // markToMatchList, so once we get said position, we see if the char
         // in the same position in the possibleMatchList is the same as the 
         // passed possibleMatch char.
         //
         // But it's actually more complex than that. Both lists may contain arrays
         // as well as strings. So we also need to see if the markToMatch char is in
         // an array within the markToMatchList array. If so, we use the position of 
         // that subarray. And when we look at the contents that are at that position
         // in the possibleMatchList array, if it's a string we just see if it matches,
         // if it's an array we see if one of its items matches.
         //
         // These comments are written very quickly, but are hopefully better than nothing  :)
         if (markToMatch.length != 1)
            Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): markToMatch must be a one-char string");
         if (possibleMatch.length != 1)
            Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): possibleMatch must be a one-char string");
         if (markToMatchList.length != possibleMatchList.length)
            Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): markToMatchList and possibleMatchList aren't the same length");
         var indexOfMarkToMatchInList:int = -1;
         var currIndex:int = -1;
         var subArray:Array;
         var subArrayItem:String;
         var bIndexFound:Boolean = false;
         for each (var markToMatchListItem:Object in markToMatchList) {
            if (bIndexFound)
               break;
            currIndex ++;
            if (markToMatchListItem is String) {
               if (String(markToMatchListItem).length != 1)
                  Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): all string items in markToMatchList must be one-char strings");
               if (markToMatchListItem == markToMatch) {
                  indexOfMarkToMatchInList = currIndex;
                  break;
               }
            } else if (markToMatchListItem is Array) {
               subArray = (markToMatchListItem as Array);
               for each (subArrayItem in subArray) {
                  if (subArrayItem.length != 1)
                     Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): all items in markToMatchList sub-arrays must be strings");
                  if (subArrayItem == markToMatch) {
                     indexOfMarkToMatchInList = currIndex;
                     bIndexFound = true;
                     break;
                  }
               }
            } else {
               Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): item in markToMatchList is neither string nor array");
            }
         }
         if (indexOfMarkToMatchInList == -1)
            Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): can't find markToMatch in markToMatchList");
         var result:Boolean = false;
         var possibleMatchItem:Object = possibleMatchList[indexOfMarkToMatchInList];
         if (possibleMatchItem is String) {
            if (possibleMatchItem == possibleMatch)
               result = true;
         } else if (possibleMatchItem is Array) {
            subArray = (possibleMatchItem as Array);
            for each (subArrayItem in subArray) {
               if (subArrayItem == possibleMatch) {
                  result = true;
                  break;
               }
            }
         } else {
            Log.fatal("Analyzer_ScriptChunk.doesPunctuationMarkMatchPunctuationMark(): item in possibleMatchList is neither string nor array");
         }
         return result
      }

      private function extractCharsContainedInPunctuationMarkListFromString(s:String, punctuationMarkList:Array):String {
         var result:String = "";
         var charCount:int = s.length;
         var currCharFromString:String;
         for (var charIndex:int = 0; charIndex < charCount; charIndex++) {
            currCharFromString = s.charAt(charIndex);
            for each (var punctuationMarkListItem:Object in punctuationMarkList) {
               if (punctuationMarkListItem is String) {
                  if (punctuationMarkListItem == currCharFromString)
                     result += currCharFromString;
               } else if (punctuationMarkListItem is Array) {
                  var subArray:Array = (punctuationMarkListItem as Array);
                  for each (var subArrayItem:String in subArray) {
                     if (subArrayItem == currCharFromString) {
                        result += currCharFromString;
                        break;
                     }
                  }
               } else {
                  Log.fatal("Analyzer_ScriptChunk.extractCharsContainedInPunctuationMarkListFromString(): item in punctuationMarkList is neither string nor array");
               }
            }
         }
         return result;
      }

      private function extractCombinedPunctuationStringFromLine(s:String):String {
         s = Utils_String.removeSubstringFromString("\\.{3}", s);
         return extractCharsContainedInPunctuationMarkListFromString(s, (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.combinedPunctuation as Array));
      }

      private function extractHanziLinePunctuationMarks(s:String):String {
         return extractCharsContainedInPunctuationMarkListFromString(s, (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.hanziPunctuation as Array));
      }

      private function extractPinyinLinePunctuationMarks(s:String):String {
         s = Utils_String.removeSubstringFromString("\\.{3}", s);
         return extractCharsContainedInPunctuationMarkListFromString(s, (Constants_Punctuation.HANZI_TO_PINYIN_PUNCTUATION_MATCHING_INFO.pinyinPunctuation as Array));
      }

      private function getIndexOfLineInLineAnalyzerListIncludingCommentLines(lineType:String):int {
         var result:int = -1;
         for (var i:int = 0; i < lineAnalyzerListIncludingCommentLines.length; i++) {
            var analyzer:Analyzer_ScriptLine = lineAnalyzerListIncludingCommentLines[i];
            if (analyzer.lineTypeId == lineType) {
               result = i;
               break;
            }
         }
         if (result == -1)
            Log.fatal("Analyzer_ScriptChunk.getIndexOfLineInLineAnalyzerListIncludingCommentLines(): no line analyzer of that type is in list");
         return result;
      }

   }
}








