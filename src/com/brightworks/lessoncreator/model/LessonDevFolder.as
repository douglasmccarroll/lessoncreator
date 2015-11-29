package com.brightworks.lessoncreator.model {
   import com.brightworks.constant.Constant_ReleaseType;
   import com.brightworks.lessoncreator.analyzers.Analyzer_Script;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.fixes.Fix_Lesson_IncorrectFileName_Credits;
   import com.brightworks.lessoncreator.fixes.Fix_Lesson_IncorrectFileName_Script;
   import com.brightworks.lessoncreator.fixes.Fix_Lesson_IncorrectFileName_Xml;
   import com.brightworks.lessoncreator.fixes.Fix_Lesson_MissingRequiredSubfolders;
   import com.brightworks.lessoncreator.fixes.Fix_Lesson_MissingFile_Script;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_File;
   import com.brightworks.util.Utils_String;
   import com.brightworks.util.Utils_XML;
   import com.brightworks.util.text.PinyinProcessor;

   import flash.filesystem.File;

   import mx.collections.ArrayCollection;

   public class LessonDevFolder {
      public var folder:File;
      public var lessonId:String;
      public var scriptText:String;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get lessonXml():XML {
         if (!doesProblemFreeScriptFileExist())
            return null;
         var result:XML = _scriptAnalyzer.lessonXml;
         if (getFile_credits()) {
            var creditsXml:XML = Utils_XML.synchronousLoadXML(getFile_credits(), false);
            if (creditsXml)
               result.appendChild(creditsXml);
         }
         return result;
      }

      public function get lessonIdFinalSegment():String {
         var segmentList:Array = lessonId.split(".");
         var result:String = String(segmentList[segmentList.length - 1]);
         return result;
      }

      public function get lessonName():String {
         if (!doesProblemFreeScriptFileExist())
            return null;
         var result:String = _scriptAnalyzer.lessonName;
         return result;
      }

      public function get level():String {
         if (!doesProblemFreeScriptFileExist())
            return null;
         var result:String = _scriptAnalyzer.level;
         return result;
      }

      public function get libraryId():String {
         if (!doesProblemFreeScriptFileExist())
            return null;
         var result:String = _scriptAnalyzer.libraryId;
         return result;
      }

      public function get nativeLanguageISO639_3Code():String {
         if (!doesProblemFreeScriptFileExist())
            return null;
         var result:String = _scriptAnalyzer.nativeLanguageISO639_3Code;
         return result;
      }

      public function get releaseType():String {
         if (!doesProblemFreeScriptFileExist())
            return null;
         return _scriptAnalyzer.releaseType;
      }

      public function get roleList():Array {
         if (!doesProblemFreeScriptFileExist())
            return null;
         return _scriptAnalyzer.roleList;
      }

      private var _scriptAnalyzer:Analyzer_Script;

      public function get scriptAnalyzer():Analyzer_Script {
         return _scriptAnalyzer;
      }

      public function get targetLanguageISO639_3Code():String {
         if (!doesProblemFreeScriptFileExist())
            return null;
         var result:String = _scriptAnalyzer.targetLanguageISO639_3Code;
         return result;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function LessonDevFolder(folder:File) {
         if (!folder.isDirectory) {
            Log.error("LessonDevFolder constructor: Passed File instance isn't a directory");
            return;
         }
         this.folder = folder;
         lessonId = folder.name;
         init();
      }

      public function doesFolderContainScriptFolder():Boolean {
         if (!folder)
            return false;
         var scriptFolder:File = Utils_File.getSubfolderFromFolderByName(folder, Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__SCRIPT);
         if ((!scriptFolder) || (!scriptFolder.isDirectory))
            return false;
         return true;
      }

      public function doesProblemFreeScriptFileExist():Boolean {
         if (!getFile_script())
            return false;
         if (!_scriptAnalyzer)
            return false;
         if (_scriptAnalyzer.doProblemsExist())
            return false;
         return true;
      }

      public function getFile_credits():File {
         if (!getSubfolder_credits())
            return null;
         if (Utils_File.getCountOfFilesInFolder(getSubfolder_credits(), false) != 1)
            return null;
         var file:File = Utils_File.getSingleFileInFolder(getSubfolder_credits());
         if (file.name == getFileName_credits())
            return file;
         else
            return null;
      }

      public function getFile_script():File {
         if (!getSubfolder_script())
            return null;
         if (Utils_File.getCountOfFilesInFolder(getSubfolder_script(), false) != 1)
            return null;
         var file:File = Utils_File.getSingleFileInFolder(getSubfolder_script());
         if (file.name == getFileName_script())
            return file;
         else
            return null;
      }

      public function getFile_xml():File {
         if (!getSubfolder_xml())
            return null;
         if (Utils_File.getCountOfFilesInFolder(getSubfolder_xml(), false) != 1)
            return null;
         var file:File = Utils_File.getSingleFileInFolder(getSubfolder_xml());
         if (file.name == getFileName_xml())
            return file;
         else
            return null;
      }

      public function getFileName_credits():String {
         return lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_CREDITS_FILE;
      }

      public function getFileName_script():String {
         return lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_SCRIPT_FILE;
      }

      public function getFileName_xml():String {
         return lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_XML_FILE;
      }

      public function getLessonProblemList():ArrayCollection {
         init(); // This creates a new script analyzer, etc (if script file exists) every time this method is called, so it's distinctly inefficient. But it makes our code simpler to simply do this each time, unless/until we see performance problems.
         var result:ArrayCollection = new ArrayCollection();
         var problem:LessonProblem;
         problem = checkForMissingRequiredSubfolders();
         if (problem)
            result.addItem(problem);
         problem = checkForSubfoldersInRequiredFolders();
         if (problem)
            result.addItem(problem);
         if (getSubfolder_credits()) {
            problem = checkFileCountInCreditsFolder();
            if (problem) {
               result.addItem(problem);
            } else {
               problem = checkCreditsFileName();
               if (problem)
                  result.addItem(problem);
            }
         }
         if (getSubfolder_script()) {
            problem = checkFileCountInScriptFolder();
            if (problem) {
               result.addItem(problem);
            } else if (Utils_File.getCountOfFilesInFolder(getSubfolder_script(), false) == 1) {
               problem = checkScriptFileName();
               if (problem)
                  result.addItem(problem);
            }
         }
         if (getSubfolder_xml()) {
            problem = checkFileCountInXmlFolder(); // Todo - Once this is a temp file, i.e. we've separated out credits info, implement fix as deleting files
            if (problem) {
               result.addItem(problem);
            } else if (Utils_File.getCountOfFilesInFolder(getSubfolder_xml(), false) == 1) {
               problem = checkXmlFileName();
               if (problem)
                  result.addItem(problem);
            }
         }
         if ((getFile_script()) && _scriptAnalyzer.doProblemsExist()) {
            for each (problem in _scriptAnalyzer.problemList) {
               result.addItem(problem);
            }
         }
         return result;
      }

      public function getListOfRequiredLessonDevFolderSubfoldersMissingInFolder():Array {
         var result:Array = [];
         var existingSubfolderNameList:Array = [];
         for each (var f:File in folder.getDirectoryListing()) {
            if (f.isDirectory)
               existingSubfolderNameList.push(f.name);
         }
         for each (var name:String in Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__LIST) {
            if (existingSubfolderNameList.indexOf(name) == -1)
               result.push(name);
         }
         return result;
      }

      public function getListOfRequiredLessonDevFolderSubfoldersWithSubfolders():Array {
         var result:Array = [];
         var existingSubfolderNameList:Array = [];
         for each (var f:File in folder.getDirectoryListing()) {
            if (f.isDirectory) {
               if (Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__LIST.indexOf(f.name) != -1) {
                  if (Utils_File.doesFolderContainSubfolders(f))
                     result.push(f.name);
               }
            }
         }
         return result;
      }

      public function getSubfolder_build():File {
         return getSubfolder(Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__BUILD);
      }

      public function getSubfolder_credits():File {
         return getSubfolder(Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__CREDITS);
      }

      public function getSubfolder_mp3():File {
         return getSubfolder(Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__MP3);
      }

      public function getSubfolder_script():File {
         return getSubfolder(Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__SCRIPT);
      }

      public function getSubfolder_wav():File {
         return getSubfolder(Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__WAV);
      }

      public function getSubfolder_xml():File {
         return getSubfolder(Constants_Misc.LESSON_DEV_FOLDER__SUBFOLDER_NAME__XML);
      }

      public function refresh():void {
         if (getLessonProblemList().length == 0) {
            // getLessonProblemList() call updates script analyzer, so we'll be writing current info here...
            updateXmlFileIfScriptFileIsProblemFree();
         }
      }

      public function updateXmlFileIfScriptFileIsProblemFree():void {
         if (!doesProblemFreeScriptFileExist())
            return;
         writeXmlFile(lessonXml.toXMLString());
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private function checkCreditsFileName():LessonProblem {
         var problem:LessonProblem;
         var file:File = getFile_credits();
         if ((file) && (file.exists) && (file.name != getFileName_credits())) {
            problem = new LessonProblem(
               this,
               "Incorrect credits file name",
               LessonProblem.PROBLEM_TYPE__INCORRECT_CREDITS_FILE_NAME,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               new Fix_Lesson_IncorrectFileName_Credits());
         }
         return problem;
      }

      private function checkFileCountInCreditsFolder():LessonProblem {
         var fileCount:uint = Utils_File.getCountOfFilesInFolder(getSubfolder_credits(), false);
         var problem:LessonProblem;
         if (fileCount > 1) {
            problem = new LessonProblem(
               this,
               "Multiple files in credits folder",
               LessonProblem.PROBLEM_TYPE__MULTIPLE_FILES_IN_CREDITS_FOLDER,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT);
         }
         return problem;
      }

      private function checkFileCountInScriptFolder():LessonProblem {
         var fileCount:uint = Utils_File.getCountOfFilesInFolder(getSubfolder_script(), false);
         var problem:LessonProblem;
         if (fileCount == 0) {
            problem = new LessonProblem(
               this,
               "Script file missing",
               LessonProblem.PROBLEM_TYPE__MISSING_SCRIPT_FILE,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               new Fix_Lesson_MissingFile_Script());
         }
         if (fileCount > 1) {
            problem = new LessonProblem(
               this,
               "Multiple files in script folder",
               LessonProblem.PROBLEM_TYPE__MULTIPLE_FILES_IN_SCRIPT_FOLDER,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT);
         }
         return problem;
      }

      private function checkFileCountInXmlFolder():LessonProblem {
         var fileCount:uint = Utils_File.getCountOfFilesInFolder(getSubfolder_xml(), false);
         var problem:LessonProblem;
         if (fileCount > 1) {
            problem = new LessonProblem(
               this,
               "Multiple files in xml folder",
               LessonProblem.PROBLEM_TYPE__MULTIPLE_FILES_IN_XML_FOLDER,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT);
         }
         return problem;
      }

      private function checkForMissingRequiredSubfolders():LessonProblem {
         if (doesFolderContainAllRequiredLessonDevFolderSubfolders())
            return null;
         var missingSubfolderList:Array = getListOfRequiredLessonDevFolderSubfoldersMissingInFolder();
         var subfolderOrSubfolders:String = (missingSubfolderList.length > 1) ? "subfolders" : "subfolder";
         var problemDescription:String = "Missing required " + subfolderOrSubfolders + ": ";
         var isFirstInList:Boolean = true;
         for each (var subfolderName:String in missingSubfolderList) {
            if (!isFirstInList) {
               problemDescription += ", ";
            }
            problemDescription += '"' + subfolderName + '"';
            isFirstInList = false;
         }
         var problem:LessonProblem =
            new LessonProblem(
            this,
            problemDescription,
            LessonProblem.PROBLEM_TYPE__MISSING_REQUIRED_SUBFOLDERS,
            LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
            new Fix_Lesson_MissingRequiredSubfolders());
         return problem;
      }

      private function checkForSubfoldersInRequiredFolders():LessonProblem {
         if (!doAnyRequiredFoldersContainSubfolders())
            return null;
         var problematicSubfolderList:Array = getListOfRequiredLessonDevFolderSubfoldersWithSubfolders();
         var subfolderOrSubfolders:String = (problematicSubfolderList.length > 1) ? "subfolders" : "subfolder";
         var problemDescription:String = "Required " + subfolderOrSubfolders + " containing subfolders: "
         var isFirstInList:Boolean = true;
         for each (var sf:File in problematicSubfolderList) {
            if (!isFirstInList) {
               problemDescription += ", ";
            }
            problemDescription += '"' + sf + '"';
            isFirstInList = false;
         }
         var problem:LessonProblem =
            new LessonProblem(
            this,
            problemDescription,
            LessonProblem.PROBLEM_TYPE__REQUIRED_SUBFOLDERS_CONTAINING_SUBFOLDERS,
            LessonProblem.PROBLEM_LEVEL__WORRISOME);
         return problem;
      }

      private function checkScriptFileName():LessonProblem {
         var problem:LessonProblem;
         var file:File = getFile_script();
         if (file.name != getFileName_script()) {
            problem = new LessonProblem(
               this,
               "Incorrect script file name",
               LessonProblem.PROBLEM_TYPE__INCORRECT_SCRIPT_FILE_NAME,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               new Fix_Lesson_IncorrectFileName_Script());
         }
         return problem;
      }

      private function checkXmlFileName():LessonProblem {
         var problem:LessonProblem;
         var file:File = getFile_xml();
         if ((file) && (file.exists) && (file.name != getFileName_xml())) {
            problem = new LessonProblem(
               this,
               "Incorrect XML file name",
               LessonProblem.PROBLEM_TYPE__INCORRECT_XML_FILE_NAME,
               LessonProblem.PROBLEM_LEVEL__IMPEDIMENT,
               new Fix_Lesson_IncorrectFileName_Xml());
         }
         return problem;
      }

      private function cleanupScript(s:String):String {
         var result:String = Utils_String.removeWhiteSpaceAtBeginningsOfLines(s);
         result = Utils_String.removeWhiteSpaceIncludingLineReturnsFromEndOfString(s) + "\n\n";
         return result;
      }

      private function doAnyRequiredFoldersContainSubfolders():Boolean {
         var result:Boolean = (getListOfRequiredLessonDevFolderSubfoldersWithSubfolders().length > 0);
         return result;
      }

      private function doesFolderContainAllRequiredLessonDevFolderSubfolders():Boolean {
         var result:Boolean = (getListOfRequiredLessonDevFolderSubfoldersMissingInFolder().length == 0);
         return result;
      }

      private function getSubfolder(subfolderName:String):File {
         var result:File;
         for each (var subfolder:File in folder.getDirectoryListing()) {
            if (subfolder.name == subfolderName) {
               result = subfolder;
               break;
            }
         }
         return result;
      }

      private function init():void {
         _scriptAnalyzer = new Analyzer_Script(this);
         var scriptFile:File = getFile_script();
         if (!scriptFile)
            return;
         var scriptText:String = readScriptTextFromFile();
         var cleanedText:String = cleanupScript(scriptText);
         this.scriptText = cleanedText;
         if (cleanedText.length != scriptText.length)
            writeScriptFile(cleanedText);
         _scriptAnalyzer.init(scriptText);
      }

      private function readScriptTextFromFile():String {
         var result:String = Utils_File.readTextFile(getFile_script());
         return result;
      }

      private function writeScriptFile(s:String):void {
         Utils_File.writeTextFile(getFile_script(), s);
      }

      private function writeXmlFile(s:String):void {
         var f:File = getFile_xml();
         if (f) {
            Utils_File.writeTextFile(f, s);
         } else {
            if (Utils_File.getCountOfFilesInFolder(getSubfolder_xml(), false) > 0) {
               Log.warn("LessonDevFolder.writeXmlFile(): Can't obtain file yet file count in folder > 0")
            }
            f = getSubfolder_xml().resolvePath(getFileName_xml());
            Utils_File.writeTextFile(f, s);
         }
      }

   }
}