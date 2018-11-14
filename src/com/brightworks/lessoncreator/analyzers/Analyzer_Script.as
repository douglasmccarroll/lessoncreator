package com.brightworks.lessoncreator.analyzers {
import com.brightworks.constant.Constant_ReleaseType;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.lessoncreator.constants.Constants_Misc;
import com.brightworks.lessoncreator.fixes.Fix;
import com.brightworks.lessoncreator.fixes.Fix_Script_BlankScript;
import com.brightworks.lessoncreator.fixes.Fix_Script_ChunkLinesWithoutRole;
import com.brightworks.lessoncreator.fixes.Fix_Script_DefectiveHeader;
import com.brightworks.lessoncreator.fixes.Fix_Script_IndeterminateLineType;
import com.brightworks.lessoncreator.fixes.Fix_Script_IndeterminateSentenceEnd_PhoneticTargetText;
import com.brightworks.lessoncreator.fixes.Fix_Script_NoBlankLines;
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.lessoncreator.model.MainModel;
import com.brightworks.lessoncreator.problems.LessonProblem;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_DataConversionComparison;
import com.brightworks.util.Utils_String;
import com.brightworks.util.text.PinyinProcessor;

import flash.utils.Dictionary;

public class Analyzer_Script extends Analyzer {
   public var lessonDevFolder:LessonDevFolder;

   private var _bProblemsWithRoles:Boolean;
   private var _chunkAnalyzerList:Array; // contains Analyzer_ScriptChunk instances
   private var _chunkAnalyzersSortedByRole:Dictionary;
   private var _currentChunkLineTypes:Array;
   private var _currentHeaderLineTypes:Array;
   private var _headerLineNumber_AuthorName:int = 1;
   private var _headerLineNumber_LessonId:int = 4;
   private var _headerLineNumber_LessonName:int = 2;
   private var _headerLineNumber_LessonSortName:int = 3;
   private var _headerLineNumber_Level:int = 9;
   private var _headerLineNumber_LibraryId:int = 6;
   private var _headerLineNumber_NativeLanguage:int = 7;
   private var _headerLineNumber_ProviderId:int = 5;
   private var _headerLineNumber_ReleaseType:int = 11;
   private var _headerLineNumber_Roles:int = 10;
   private var _headerLineNumber_TargetLanguage:int = 8;
   private var _lineAnalyzerList:Array; // contains Analyzer_ScriptLine instances
   private var _lineCount:int;
   private var _lineStringList:Array; // an Array of strings, one for each line
   [Bindable]
   private var _resultsString:String;
   private var _scriptText:String;

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Getters / Setters
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   private var _chunkCount:int;

   public function get chunkCount():int {
      return _chunkCount;
   }

   public function get defaultTextDisplayType():String {
      var result:String;
      if (MainModel.getInstance().languageConfigInfo.doesLanguageRequireUseOfPhoneticTargetLanguageLineInScript(targetLanguageISO639_3Code)) {
         result = "textTargetLanguagePhonetic";
      } else {
         result = "textTargetLanguage";
      }
      return result;
   }

   public function get isDualLanguage():Boolean {
      return (nativeLanguageISO639_3Code.length == 3);
   }

   public function get lessonName():String {
      return Analyzer_ScriptLine_Header_LessonName(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_LessonName)).getLessonName();
   }

   public function get lessonSortName():String {
      return Analyzer_ScriptLine_Header_LessonSortName(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_LessonSortName)).getLessonSortName();
   }

   public function get lessonXml():XML {
      var result:XML = <lesson/>;
      var xmlElement:XML;
      xmlElement = <lessonName>{lessonName}</lessonName>;
      result.appendChild(xmlElement);
      xmlElement = <lessonSortName>{lessonSortName}</lessonSortName>;
      result.appendChild(xmlElement);
      var isAlphaReviewVersionString:String = (releaseType == Constant_ReleaseType.ALPHA_CAPITALIZED) ? "true" : "false";
      xmlElement = <isAlphaReviewVersion>{isAlphaReviewVersionString}</isAlphaReviewVersion>;
      result.appendChild(xmlElement);
      var isDualLanguageString:String = (isDualLanguage) ? "true" : "false";
      xmlElement = <isDualLanguage>{isDualLanguageString}</isDualLanguage>;
      result.appendChild(xmlElement);
      if (isDualLanguage) {
         xmlElement = <nativeLanguageISO639_3Code>{nativeLanguageISO639_3Code}</nativeLanguageISO639_3Code>;
         result.appendChild(xmlElement);
      }
      xmlElement = <targetLanguageISO639_3Code>{targetLanguageISO639_3Code}</targetLanguageISO639_3Code>;
      result.appendChild(xmlElement);
      xmlElement = <level>{level}</level>;
      result.appendChild(xmlElement);
      xmlElement = <defaultTextDisplayType>{defaultTextDisplayType}</defaultTextDisplayType>;
      result.appendChild(xmlElement);
      result.appendChild(createXML_ChunksElement());
      return result;
   }

   public function get level():String {
      return Analyzer_ScriptLine_Header_Level(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_Level)).getLevel();
   }

   public function get libraryId():String {
      return Analyzer_ScriptLine_Header_LibraryId(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_LibraryId)).getLibraryId();
   }

   public function get nativeLanguageISO639_3Code():String {
      return Analyzer_ScriptLine_Header_NativeLanguage(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_NativeLanguage)).getNativeLanguage();
   }

   private var _problemList:Array; // an Array of LessonProblem instances

   public function get problemList():Array {
      return _problemList;
   }

   public function get releaseType():String {
      var lineAnalyzer:Analyzer_ScriptLine = getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_ReleaseType);
      if (!lineAnalyzer)
         return Constant_ReleaseType.UNDEFINED_CAPITALIZED;
      if (lineAnalyzer.getProblems().length > 0)
         return Constant_ReleaseType.UNDEFINED_CAPITALIZED;
      if (!(lineAnalyzer is Analyzer_ScriptLine_Header_ReleaseType)) {
         Log.warn("Analyzer_Script.get releaseType(): line analyzer is incorrect type");
         return Constant_ReleaseType.UNDEFINED_CAPITALIZED;
      }
      return Analyzer_ScriptLine_Header_ReleaseType(lineAnalyzer).getReleaseType();
   }

   public function get roleList():Array {
      var rolesLineAnalyzer:Analyzer_ScriptLine_Header_Roles = Analyzer_ScriptLine_Header_Roles(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_Roles));
      return rolesLineAnalyzer.getRoleList();
   }

   public function get targetLanguageISO639_3Code():String {
      var a:Analyzer_ScriptLine_Header_TargetLanguage = Analyzer_ScriptLine_Header_TargetLanguage(getLineAnalyzerForLineNumberNotCountingCommentLines(_headerLineNumber_TargetLanguage));
      if (a) {
         return a.getTargetLanguage();
      } else {
         return null;
      }
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Public Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   public function Analyzer_Script(lessonDevFolder:LessonDevFolder) {
      this.lessonDevFolder = lessonDevFolder;
   }

   /*public function createVoiceScriptsInfo():VoiceScriptsInfo {
      if (doProblemsExist())
         Log.fatal("Analyzer_Script.createVoiceScriptsInfo(): Problems exist.");
      var result:VoiceScriptsInfo = new VoiceScriptsInfo();
      result.languageInfoList = new Dictionary();
      result.languageInfoList[Constants_Language.ISO_639_3_CODE__CMN] = createVoiceScriptsInfo_CreateVoiceScriptsLanguageInfo_Chinese();
      result.languageInfoList[Constants_Language.ISO_639_3_CODE__ENG] = createVoiceScriptsInfo_CreateVoiceScriptsLanguageInfo_English();
      return result;
   }*/

   public function doProblemsExist():Boolean {
      return ((_problemList) && (_problemList.length > 0));
   }

   public function getAllowedNonCommentChunkLineCount_Maximum():int {
      return MainModel.getInstance().languageConfigInfo.getAllowedNonCommentChunkLineCount_Maximum(targetLanguageISO639_3Code);
   }

   public function getAllowedNonCommentChunkLineCount_Minimum():int {
      return MainModel.getInstance().languageConfigInfo.getAllowedNonCommentChunkLineCount_Minimum(targetLanguageISO639_3Code);
   }

   public function getChunkAnalyzer(chunkNum:uint):Analyzer_ScriptChunk {
      if (chunkNum > _chunkCount) {
         Log.error("Analyzer_Script.getChunkAnalyzer(): chunkNum too high");
         return null;
      }
      var result:Analyzer_ScriptChunk = _chunkAnalyzerList[chunkNum - 1];
      return result;
   }

   public function getChunkLineStyleName_Native(capitalize:Boolean):String {
      return MainModel.getInstance().languageConfigInfo.getChunkLineStyleName_Native(capitalize);
   }

   public function getChunkLineStyleName_Target(capitalize:Boolean):String {
      return MainModel.getInstance().languageConfigInfo.getChunkLineStyleName_Target(targetLanguageISO639_3Code, capitalize);
   }

   public function getChunkLineStyleName_TargetRomanized(capitalize:Boolean):String {
      return MainModel.getInstance().languageConfigInfo.getChunkLineStyleName_TargetRomanized(targetLanguageISO639_3Code, capitalize);
   }

   public function init(scriptText:String):void {
      // If we can assume that we have a blank line at the end of our script it
      // simplifies our code. See analyzeChunks_CreateChunkAnalyzerList in
      // particular - it checks to see if it has "chunk data" from previous lines
      // on each non-chunk line. If there is no non-chunk line after the last
      // chunk it doesn't create a Analyzer_ScriptChunk instance for the last chunk.
      scriptText += "\n"
      analyze_InitProps(scriptText);
      // The next method checks each line and makes an initial determination of it's
      // type based on its position within the script, etc. We don't check the line's
      // contents at this point so this may not really identify what type of line the
      // line is. We may or may not check all of the lines - for example, if the script
      // doesn't have the correct number of header lines we abort. Once each line passes
      // this initial check a Analyzer_ScriptLine instance is created and added to
      // _lineAnalyzerList.
      analyzeLines_CreateLineAnalyzerList();
      if (doProblemsExist())
         return;
      analyzeLines_CheckLinesForProblems_RoleLines();
      if (doProblemsExist())
         return;
      analyzeLines_SetRoleInfo();
      if (doProblemsExist())
         return;
      analyzeChunks_CreateChunkAnalyzerLists();
      if (doProblemsExist())
         return;
      analyzeLines_CheckLinesForProblems_NonRoleLines();
      if (doProblemsExist())
         return;
      analyzeChunks_CheckChunks();
      analyzeChunks_CheckChunkRelationships();
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Private Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   private function addChunkAnalyzerToChunkAnalyzersSortedByRole(analyzer:Analyzer_ScriptChunk):void {
      var roleName:String = analyzer.roleName;
      if (!roleName)
         roleName = Constants_Misc.ROLE_DEFAULT;
      if (!_chunkAnalyzersSortedByRole.hasOwnProperty(roleName))
         _chunkAnalyzersSortedByRole[roleName] = [];
      (_chunkAnalyzersSortedByRole[roleName] as Array).push(analyzer);
   }

   private function addProblemsToProblemList(problemList:Array):void {
      for each (var problem:LessonProblem in problemList) {
         addProblemToProblemList(problem);
      }
   }

   private function addProblemToProblemList(problem:LessonProblem):void {
      _problemList.push(problem);
   }

   private function addProblemToProblemList_ChunkLinesWithNoRole(lineAnalyzerList:Array):void {
      var lineNumber_FirstLine:uint = Analyzer_ScriptLine(lineAnalyzerList[0]).lineNumber;
      var fix:Fix = new Fix_Script_ChunkLinesWithoutRole(this, lineAnalyzerList, lineNumber_FirstLine);
      var problem:LessonProblem = new LessonProblem(
            lessonDevFolder,
            "Chunk(s) with no role",
            LessonProblem.PROBLEM_TYPE__SCRIPT__CHUNK_LINES_WITHOUT_ROLE,
            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
            fix,
            this);
      addProblemToProblemList(problem);
   }

   private function addProblemToProblemList_DefectiveHeader():void {
      var fix:Fix = new Fix_Script_DefectiveHeader(this, getNumberOfNonCommentLinesBeforeFirstBlankLine());
      var problem:LessonProblem = new LessonProblem(
            lessonDevFolder,
            "Defective script header",
            LessonProblem.PROBLEM_TYPE__SCRIPT__DEFECTIVE_HEADER,
            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
            fix,
            this);
      addProblemToProblemList(problem);
   }

   private function addProblemToProblemList_EmptyScript():void {
      var fix:Fix = new Fix_Script_BlankScript(this);
      var problem:LessonProblem = new LessonProblem(
            lessonDevFolder,
            "Empty script",
            LessonProblem.PROBLEM_TYPE__SCRIPT__BLANK_SCRIPT_FILE,
            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
            fix,
            this);
      addProblemToProblemList(problem);
   }

   private function addProblemToProblemList_IndeterminateLineType(lineNumber:int):void {
      var fix:Fix = new Fix_Script_IndeterminateLineType(this, lineNumber);
      var problem:LessonProblem = new LessonProblem(
            lessonDevFolder,
            "Cannot interpret line in script",
            LessonProblem.PROBLEM_TYPE__SCRIPT__INDETERMINATE_LINE_TYPE,
            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
            fix,
            this);
      addProblemToProblemList(problem);
   }

   private function addProblemToProblemList_ScriptHasNoBlankLines():void {
      var fix:Fix = new Fix_Script_NoBlankLines(this);
      var problem:LessonProblem = new LessonProblem(
            lessonDevFolder,
            "Script has no blank lines",
            LessonProblem.PROBLEM_TYPE__SCRIPT__SCRIPT_HAS_NO_BLANK_LINES,
            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
            fix,
            this);
      addProblemToProblemList(problem);
   }

   private function analyze_InitProps(scriptText:String):void {
      _scriptText = scriptText;
      _bProblemsWithRoles = false;
      _currentChunkLineTypes = [];
      _currentHeaderLineTypes = [];
      _lineAnalyzerList = [];
      _lineStringList = Utils_DataConversionComparison.convertStringToArrayOfLineStrings(_scriptText, true);
      _lineCount = _lineStringList.length;
      _problemList = [];
      _resultsString = "";
   }

   private function analyzeChunks_CheckChunkRelationships():void {
      var problemString:String;
      for (var roleName:String in _chunkAnalyzersSortedByRole) {
         var chunkListForRole:Array = _chunkAnalyzersSortedByRole[roleName];
         var analyzerCount:int = chunkListForRole.length;
         for (var i:int = 0; i < (analyzerCount - 1); i++) {
            var firstAnalyzerInPair:Analyzer_ScriptChunk = chunkListForRole[i];
            if (firstAnalyzerInPair.isChunkExemptFromPunctuationChecking())
               continue;
            var secondAnalyzerInPair:Analyzer_ScriptChunk = chunkListForRole[i + 1];
            if (secondAnalyzerInPair.isChunkExemptFromPunctuationChecking())
               continue;
            if (secondAnalyzerInPair.isLinePrecededByIgnoreProblemsCommentLine(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC))
               continue;
            if (firstAnalyzerInPair.isPinyinLineFinalOrOnlyChunkInSentence()) {
               if (!secondAnalyzerInPair.isPinyinLineFirstOrOnlyChunkInSentence()) {
                  var firstLineNumber:uint = firstAnalyzerInPair.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
                  var secondLineNumber:uint = secondAnalyzerInPair.getLineNumber(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC);
                  var fix:Fix = new Fix_Script_IndeterminateSentenceEnd_PhoneticTargetText(this, firstLineNumber, secondLineNumber);
                  var problem:LessonProblem = new LessonProblem(
                        lessonDevFolder,
                        getChunkLineStyleName_TargetRomanized(true) + " punctuation problem",
                        LessonProblem.PROBLEM_TYPE__SCRIPT__INDETERMINATE_SENTENCE_END__ROMANIZED_TARGET_TEXT,
                        LessonProblem.PROBLEM_LEVEL__WORRISOME,
                        fix);
                  addProblemToProblemList(problem);
               }
            }
         }
      }
   }

   private function analyzeChunks_CheckChunks():void {
      var chunkAnalyzer:Analyzer_ScriptChunk;
      for (var i:int = 0; i < _chunkCount; i++) {
         chunkAnalyzer = _chunkAnalyzerList[i];
         addProblemsToProblemList(chunkAnalyzer.getProblems());
      }
   }

   private function analyzeChunks_CreateChunkAnalyzerLists():void {
      _chunkAnalyzerList = [];
      _chunkAnalyzersSortedByRole = new Dictionary();
      var currentChunkAndCommentLineAnalyzerList:Array = [];
      var newChunkAnalyzer:Analyzer_ScriptChunk;
      var currChunkNumber:int = 0;
      var currRoleName:String;
      for each (var lineAnalyzer:Analyzer_ScriptLine in _lineAnalyzerList) {
         if ((lineAnalyzer.isChunkLine) || (lineAnalyzer is Analyzer_ScriptLine_Comment)) {
            currentChunkAndCommentLineAnalyzerList.push(lineAnalyzer);
         } else {
            // Not a chunk line - do we have a chunk's data to process?
            var chunkLineAnalyzerCount:uint = computeNumberOfChunkLineAnalyzersInList(currentChunkAndCommentLineAnalyzerList);
            if (chunkLineAnalyzerCount == 0) {
               // Do nothing - no data to process
            } else if ((chunkLineAnalyzerCount >= getAllowedNonCommentChunkLineCount_Minimum()) && (chunkLineAnalyzerCount <= getAllowedNonCommentChunkLineCount_Maximum())) {
               // Yes, we have data to process. Create an Analyzer_ScriptChunk instance.
               currChunkNumber++;
               newChunkAnalyzer = new Analyzer_ScriptChunk(this);
               newChunkAnalyzer.chunkNumber = currChunkNumber;
               newChunkAnalyzer.lineCode = Utils_String.padBeginning(String(currChunkNumber), 2, "0");
               newChunkAnalyzer.nativeLanguageIso639_3Code = nativeLanguageISO639_3Code;
               newChunkAnalyzer.targetLanguageIso639_3Code = targetLanguageISO639_3Code;
               if (currRoleName) {
                  newChunkAnalyzer.roleName = currRoleName;
               } else {
                  if (doesScriptUseDefaultRole()) {
                     newChunkAnalyzer.roleName = Constants_Misc.ROLE_DEFAULT;
                  } else {
                     Log.fatal("Analyzer_Script.analyzeChunks_CreateChunkAnalyzerList():  Chunk line occurs before role any role identification line - this should have been caught in 'analysis' stage and should have prevented 'create scripts' stage");
                  }
               }
               for each (var subLoopLineAnalyzer:Analyzer_ScriptLine in currentChunkAndCommentLineAnalyzerList) {
                  if (subLoopLineAnalyzer.isChunkLine) {
                     newChunkAnalyzer.addAnalyzer_ScriptLine(subLoopLineAnalyzer);
                     Analyzer_ScriptLine_Chunk(subLoopLineAnalyzer).setAnalyzer_ScriptChunk(newChunkAnalyzer);
                  }
               }
               newChunkAnalyzer.lineAnalyzerListIncludingCommentLines = currentChunkAndCommentLineAnalyzerList;
               _chunkAnalyzerList.push(newChunkAnalyzer);
               addChunkAnalyzerToChunkAnalyzersSortedByRole(newChunkAnalyzer);
               // Reset list, ready to gather data for a next chunk
               currentChunkAndCommentLineAnalyzerList = [];
            } else {
               Log.fatal("Analyzer_Script.analyzeChunks_CreateChunkAnalyzerList(): " + currentChunkAndCommentLineAnalyzerList.length + "- should always be 3 or 4");
            }
            if (lineAnalyzer is Analyzer_ScriptLine_RoleIdentification) {
               currRoleName = Analyzer_ScriptLine_RoleIdentification(lineAnalyzer).roleName;
            }
         }
      }
      _chunkCount = _chunkAnalyzerList.length;
   }

   private function analyzeLines_CheckLinesForProblems_NonRoleLines():void {
      var lineAnalyzer:Analyzer_ScriptLine;
      for (var i:int = 0; i < _lineCount; i++) {
         lineAnalyzer = _lineAnalyzerList[i];
         if (isLineRoleLine(i + 1))
            continue;
         if (!isLineIgnoreProblemsCommentLine(i)) {
            addProblemsToProblemList(lineAnalyzer.getProblems());
            isLineIgnoreProblemsCommentLine(i) // For debugging
         } else {
            var foo:int = 0;
         }

      }
   }

   private function analyzeLines_CheckLinesForProblems_RoleLines():void {
      var lineAnalyzer:Analyzer_ScriptLine;
      for (var i:int = 0; i < _lineCount; i++) {
         lineAnalyzer = _lineAnalyzerList[i];
         if (!isLineRoleLine(i + 1))
            continue;
         addProblemsToProblemList(lineAnalyzer.getProblems());
      }
   }

   private function analyzeLines_CreateLineAnalyzerList():void {
      if (!doesScriptHaveAnyBlankLines()) {
         addProblemToProblemList_ScriptHasNoBlankLines();
         return;
      }
      if (getFirstBlankLineNumAfter(0) == 1) {
         addProblemToProblemList_EmptyScript();
         return;
      }
      if (getNumberOfNonCommentLinesBeforeFirstBlankLine() != Constants_Misc.LESSON_HEADER__LINE_COUNT) {
         addProblemToProblemList_DefectiveHeader();
         return;
      }
      var lineNumber:int = 0;
      var lineTypeId:String;
      var lineAnalyzer:Analyzer_ScriptLine;
      for each (var lineString:String in _lineStringList) {
         lineNumber++;
         lineTypeId = determineLineTypeId(lineNumber)
         lineAnalyzer = MainModel.getInstance().languageConfigInfo.getLineAnalyzerInstanceForLineType(lineTypeId, targetLanguageISO639_3Code, this);
         lineAnalyzer.lineNumber = lineNumber;
         lineAnalyzer.lineTypeId = lineTypeId;
         lineAnalyzer.lineText = lineString;
         _lineAnalyzerList.push(lineAnalyzer);
      }
   }

   private function analyzeLines_SetRoleInfo():void {
      var lineAnalyzer:Analyzer_ScriptLine;
      var currentRoleName:String = null;
      var problemChunkLines_NoRole_List:Array = [];
      for (var i:int = 0; i < _lineCount; i++) {
         lineAnalyzer = _lineAnalyzerList[i];
         switch (lineAnalyzer.lineTypeId) {
            case Constants_LineType.LINE_TYPE_ID__ROLE_IDENTIFICATION:
               // roleName was set in these lines in analyzeLines_CheckLinesForProblems_RoleLines()
               currentRoleName = Analyzer_ScriptLine_RoleIdentification(lineAnalyzer).roleName;
               break;
            default:
               lineAnalyzer.roleName = currentRoleName;
         }
         if (lineAnalyzer.isChunkLine) {
            if ((!currentRoleName) && (!doesScriptUseDefaultRole())) {
               problemChunkLines_NoRole_List.push(lineAnalyzer);
            }
         }
      }
      if (problemChunkLines_NoRole_List.length > 0) {
         addProblemToProblemList_ChunkLinesWithNoRole(problemChunkLines_NoRole_List);
      }
   }

   private function computeNumberOfChunkLineAnalyzersInList(list:Array):uint {
      var result:int = 0;
      for each (var analyzer:Analyzer_ScriptLine in list) {
         if (analyzer.isChunkLine)
            result++;
      }
      return result;
   }

   private function constructFullProblemString(lineNumber:int, lineText:String, problemString:String):String {
      var result:String = "Line #: " + lineNumber + "\n\nLine Text: " + lineText + "\n\nProblem: " + problemString;
      return result;
   }

   private function createXML_ChunksElement():XML {
      var result:XML = <chunks/>;
      for each (var chunkAnalyzer:Analyzer_ScriptChunk in _chunkAnalyzerList) {
         var chunkElement:XML = <chunk/>;
         var chunkNumberString:String = Utils_DataConversionComparison.convertNumberToString(chunkAnalyzer.chunkNumber, 0, true, 2, "0");
         var fileNameRootElement:XML = <fileNameRoot>{chunkNumberString}</fileNameRoot>;
         chunkElement.appendChild(fileNameRootElement);
         var nativeText:String = chunkAnalyzer.getLineText_Native();
         var textNativeLanguageElement:XML = <textNativeLanguage>{nativeText}</textNativeLanguage>;
         chunkElement.appendChild(textNativeLanguageElement);
         // TODO - so that we can display hanzi etc - rather than either/or, include both target language text and phonetic target language text
         if (MainModel.getInstance().languageConfigInfo.doesLanguageRequireUseOfPhoneticTargetLanguageLineInScript(targetLanguageISO639_3Code)) {
            var targetPhoneticText:String = chunkAnalyzer.getLineText_TargetPhonetic();
            targetPhoneticText = doesTextContainEmptyLineIndicator(targetPhoneticText) ? "" : targetPhoneticText;
            // TODO - next line is cmn-specific
            targetPhoneticText = PinyinProcessor.convertNumberToneIndicatorsToToneMarks(targetPhoneticText);
            var textTargetLanguagePhoneticElement:XML =
                  <{defaultTextDisplayType}>{targetPhoneticText}</{defaultTextDisplayType}>;
            chunkElement.appendChild(textTargetLanguagePhoneticElement);
         } else {
            var targetText:String = chunkAnalyzer.getLineText_Target();
            targetText = doesTextContainEmptyLineIndicator(targetText) ? "" : targetText;
            var textTargetLanguageElement:XML = <{defaultTextDisplayType}>{targetText}</{defaultTextDisplayType}>;
            chunkElement.appendChild(textTargetLanguageElement);
         }
         result.appendChild(chunkElement);
      }
      return result;
   }

   private function determineLineTypeId(lineNum:int):String {
      if (lineNum == 15) {
         var i:int = 0;
      }
      var result:String;
      if (isLineBlankLine(lineNum)) {
         result = Constants_LineType.LINE_TYPE_ID__BLANK;
      } else if (isLineCommentLine(lineNum)) {
         result = Constants_LineType.LINE_TYPE_ID__COMMENT;
      } else if (isLineRoleLine(lineNum)) {
         result = Constants_LineType.LINE_TYPE_ID__ROLE_IDENTIFICATION;
      } else if (isLineHeaderLine(lineNum)) {
         result = determineLineType_HeaderLine(lineNum);
      } else if (isLineChunkLine(lineNum)) {
         result = determineLineType_ChunkLine(lineNum);
      } else {
         // for debugging         TODO
         isLineChunkLine(lineNum);

         addProblemToProblemList_IndeterminateLineType(lineNum);
         result = Constants_LineType.LINE_TYPE_ID__UNKNOWN;
      }
      return result;
   }

   private function determineLineType_ChunkLine(lineNum:int):String {
      // TODO - Single-language lessons
      var result:String;
      var positionInChunk:int = getPositionOfLineInChunk(lineNum);
      if (MainModel.getInstance().languageConfigInfo.doesLanguageRequireUseOfPhoneticTargetLanguageLineInScript(targetLanguageISO639_3Code)) {
         switch (positionInChunk) {
            case 1:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC;
               break;
            case 2:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE;
               break;
            case 3:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE;
               break;
            case 4:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__NOTE;
               break;
            default:
               Log.fatal("Analyzer_Script.determineLineType_ChunkLine(): no match for positionInChunk of " + positionInChunk);
         }
      } else {
         switch (positionInChunk) {
            case 1:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE;
               break;
            case 2:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE;
               break;
            case 3:
               result = Constants_LineType.LINE_TYPE_ID__CHUNK__NOTE;
               break;
            default:
               Log.fatal("Analyzer_Script.determineLineType_ChunkLine(): no match for positionInChunk of " + positionInChunk);
         }
      }
      return result;
   }

   private function determineLineType_HeaderLine(lineNum:int):String {
      var result:String;
      var commentLineCount:int = getNumberOfCommentLinesBeforeLine(lineNum);
      switch (lineNum - commentLineCount) {
         case _headerLineNumber_AuthorName:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__AUTHOR_NAME;
            break;
         case _headerLineNumber_LessonId:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__LESSON_ID;
            break;
         case _headerLineNumber_LessonName:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__LESSON_NAME;
            break;
         case _headerLineNumber_LessonSortName:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__LESSON_SORT_NAME;
            break;
         case _headerLineNumber_Level:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__LEVEL;
            break;
         case _headerLineNumber_LibraryId:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__LIBRARY_ID;
            break;
         case _headerLineNumber_NativeLanguage:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__NATIVE_LANGUAGE;
            break;
         case _headerLineNumber_ProviderId:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__PROVIDER_ID;
            break;
         case _headerLineNumber_ReleaseType:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__RELEASE_TYPE;
            break;
         case _headerLineNumber_Roles:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__ROLES;
            break;
         case _headerLineNumber_TargetLanguage:
            result = Constants_LineType.LINE_TYPE_ID__HEADER__TARGET_LANGUAGE;
            break;
         default:
            Log.fatal("Analyzer_Script.determineLineType_HeaderLine(): no match for lineNum of " + lineNum);
      }
      return result;
   }

   private function doesScriptHaveAnyBlankLines():Boolean {
      var result:Boolean = false;
      var lineText:String;
      for (var lineNum:int = 1; lineNum <= _lineStringList.length; lineNum++) {
         lineText = _lineStringList[lineNum - 1];
         if (Analyzer_ScriptLine_Blank.isLineThisType(lineText)) {
            result = true;
            break;
         }
      }
      return result;
   }

   private function doesScriptUseDefaultRole():Boolean {
      return (roleList[0] == Constants_Misc.ROLE_DEFAULT);
   }

   private function doesTextContainEmptyLineIndicator(s:String):Boolean {
      s = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningAndEndOfString(s);
      if (s.indexOf(Constants_Misc.BLANK_LINE_INDICATOR) != -1) {
         if ((s.indexOf(Constants_Misc.BLANK_LINE_INDICATOR) != 0) || (s.length != Constants_Misc.BLANK_LINE_INDICATOR.length)) {
            Log.warn("Analyzer_Script.doesTextContainEmptyLineIndicator(): Text contains indicator but also constains other non-white-space text");
            return false;
         } else {
            return true;
         }
      } else {
         return false;
      }
   }

   private function getCountOfCommentLinesInLineGroup(firstLineNum:int, lastLineNum:int):int {
      var result:int = 0;
      if (!lastLineNum > firstLineNum)
         Log.fatal("Analyzer_Script.getCountOfCommentLinesInLineGroup(): lastLineNum must be greater than firstLineNum");
      for (var i:int = firstLineNum - 1; i < lastLineNum; i++) {
         if (isLineCommentLine(i + 1))
            result++;
      }
      return result;
   }

   private function getFirstBlankLineNumAfter(lineNum:int):int {
      // Next 2 lines are silly but, hopefully, explanatory
      var firstLineNumToCheck:int = lineNum + 1;
      var firstIndexToCheck:int = firstLineNumToCheck - 1;
      for (var i:int = firstIndexToCheck; i < _lineStringList.length; i++) {
         if (Analyzer_ScriptLine_Blank.isLineThisType(_lineStringList[i])) {
            return i + 1;
         }
      }
      // We didn't find a blank line so we return lineCount + 1.
      // In other words, for the purposes of our logic, the nonexistent line
      // after the scripts final line is considered to be "blank".
      return _lineStringList.length + 1;
   }

   private function getLastBlankLineNumBefore(lineNum:int):int {
      // We return -1 if there is no previous blank line.
      if (lineNum < 2)
         return -1;
      var firstLineNumToCheck:int = lineNum - 1;
      var firstIndexToCheck:int = firstLineNumToCheck - 1;
      for (var i:int = firstIndexToCheck; i >= 0; i--) {
         if (Analyzer_ScriptLine_Blank.isLineThisType(_lineStringList[i])) {
            return i + 1;
         }
      }
      return -1;
   }

   private function getLineAnalyzerForLineNumberNotCountingCommentLines(lineNum:int):Analyzer_ScriptLine {
      if (!_lineAnalyzerList)
         return null;
      var result:Analyzer_ScriptLine;
      var currNonCommentLineNum:int = 0;
      var currAnalyzer:Analyzer_ScriptLine;
      for (var tempLineNum:int = 1; tempLineNum <= _lineAnalyzerList.length; tempLineNum++) {
         currAnalyzer = _lineAnalyzerList[tempLineNum - 1];
         if (!(currAnalyzer is Analyzer_ScriptLine_Comment)) {
            currNonCommentLineNum++;
            if (currNonCommentLineNum == lineNum) {
               result = _lineAnalyzerList[tempLineNum - 1];
               break;
            }
         }
      }
      if (result) {
         return result;
      } else {
         // This happens sometimes. For example, we may be wondering if we can get target language code from the target
         // language header line, but we're currently still processing the first line of the script and
         // _lineAnalyzerList.length = 0. It's okay. The code that calls this just needs to be able to handle cases
         // where a line analyzer hasn't been created yet.
         return null;
      }
   }

   private function getNonplussedCommentString():String {
      var possibleCommentList:Array = [];
      possibleCommentList.push("I'm not the most intelligent software in the world and I just can't figure this out.");
      possibleCommentList.push("Being software of very little brain, this leaves me in a state of muddled confusion.");
      possibleCommentList.push("I don't understand this, but I'm only a computer program. Perhaps if you apply your superior human intelligence to this situation you'll be able to figure out what the problem is.");
      possibleCommentList.push("I don't have a clue as to why this is happening. Could you take over from here?");
      var randomChoice:int = Math.floor(3.9999 * Math.random());
      var result:String = possibleCommentList[randomChoice];
      return result;
   }

   private function getNumberOfCommentLinesBeforeLine(lineNum:int):int {
      var result:int = 0;
      var lineText:String;
      for (var tempLineNum:int = 1; tempLineNum <= lineNum; tempLineNum++) {
         lineText = _lineStringList[tempLineNum - 1];
         if (Analyzer_ScriptLine_Comment.isLineThisType(lineText))
            result++;
      }
      return result;
   }

   private function getNumberOfNonCommentLinesBeforeFirstBlankLine():int {
      var firstBlankLineNum:int = getFirstBlankLineNumAfter(0);
      if (firstBlankLineNum == 0)
         return 0;
      var result:int = (firstBlankLineNum - 1) - getNumberOfCommentLinesBeforeLine(firstBlankLineNum);
      return result;
   }

   private function getPositionOfLineInChunk(lineNum:int):int {
      if (!isLineChunkLine(lineNum))
         Log.fatal("Analyzer_Script.getPositionOfLineInChunk(): line isn't chunk line");
      var previousBlankLineNum:int = getLastBlankLineNumBefore(lineNum);
      if (previousBlankLineNum == -1)
         Log.fatal("Analyzer_Script.getPositionOfLineInChunk(): no previous blank line exists");
      if (previousBlankLineNum >= lineNum)
         Log.fatal("Analyzer_Script.getPositionOfLineInChunk(): previous blank line is greater than this line (?)");
      var commentLineCount:int = getCountOfCommentLinesInLineGroup(previousBlankLineNum + 1, lineNum - 1);
      var result:int = (lineNum - previousBlankLineNum) - commentLineCount;
      return result;
   }

   private function isLineBlankLine(lineNum:int):Boolean {
      return Analyzer_ScriptLine_Blank.isLineThisType(_lineStringList[lineNum - 1]);
   }

   private function isLineChunkLine(lineNum:int):Boolean {
      // Assumption: We're past the header.
      // For purposes of this initial line type id we simply confirm that this line is part of a group of lines bordered by
      // blank lines, where the number of non-comment lines in the group equals ((2 or 3) + _nativeLanguageCount).
      if (isLineBlankLine(lineNum))
         return false;
      var previousBlankLineNum:int = getLastBlankLineNumBefore(lineNum);
      if (previousBlankLineNum == -1)
         return false;
      var nextBlankLineNum:int = getFirstBlankLineNumAfter(lineNum);
      var linesInGroup:int = (nextBlankLineNum - previousBlankLineNum) - 1;
      var commentLinesInGroup:int = getCountOfCommentLinesInLineGroup(previousBlankLineNum + 1, nextBlankLineNum - 1);
      var nonCommentLinesInGroup:int = linesInGroup - commentLinesInGroup;
      if (nonCommentLinesInGroup < getAllowedNonCommentChunkLineCount_Minimum())
         return false;
      if (nonCommentLinesInGroup > getAllowedNonCommentChunkLineCount_Maximum())
         return false;
      return true;
   }

   private function isLineCommentLine(lineNum:int):Boolean {
      return Analyzer_ScriptLine_Comment.isLineThisType(_lineStringList[lineNum - 1])
   }

   private function isLineHeaderLine(lineNum:int):Boolean {
      // Assumption: Out code has already established that the first blank line is in
      // an appropriate place, i.e. we have an appropriate number of header lines.
      return (lineNum < getFirstBlankLineNumAfter(0));
   }

   private function isLineIgnoreProblemsCommentLine(lineNum:int):Boolean {
      if (lineNum == 0)
         return false;
      if (!Analyzer_ScriptLine_Comment.isLineThisType(_lineStringList[lineNum - 1], _lineStringList, lineNum))
         return false;
      var result:Boolean = (String(_lineStringList[lineNum - 1]).indexOf(Constants_Misc.SCRIPT_COMMENT_TAG__LINE__IGNORE_PROBLEMS) != -1);
      return result;
   }

   private function isLineRoleLine(lineNum:int):Boolean {
      return Analyzer_ScriptLine_RoleIdentification.isLineThisType(_lineStringList[lineNum - 1], _lineStringList, lineNum);
   }

}
}
