package com.brightworks.lessoncreator.model {
import com.brightworks.interfaces.IManagedSingleton;
import com.brightworks.lessoncreator.constants.Constants_ApplicationState;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_XML;
import com.brightworks.util.singleton.SingletonManager;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;

public class MainModel extends EventDispatcher implements IManagedSingleton {
   private static var _instance:MainModel;

   [Bindable]
   public var currentLessonLibrary:LessonLibrary;
   public var languageConfigInfo:LanguageConfigInfo;
   [Bindable]
   public var lessonLibraryList:ArrayCollection;
   public var productionScriptFolderPath:String;
   public var voiceTalentList:ArrayCollection;
   public var xmlConfigData_ContentRestrictions:XML;
   public var xmlConfigData_TargetLanguages:XML;

   private var _applicationState_Previous:String;
   private var _index_lessonLibraryId_to_lessonLibrary:Dictionary;

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Getters & Setters
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   private var _applicationState:String = Constants_ApplicationState.APPLICATION_STATE__PRIMARY__HOME; // Use Constants_ApplicationState

   [Bindable(event="applicationStateChange")]
   public function get applicationState():String {
      return _applicationState;
   }

   public function set applicationState(value:String):void {
      if (value != _applicationState) {
         _applicationState_Previous = _applicationState;
         _applicationState = value;
         dispatchEvent(new Event("applicationStateChange"));
      }
   }

   private var _currentLessonDevFolder:LessonDevFolder;

   public function get currentLessonDevFolder():LessonDevFolder {
      return _currentLessonDevFolder;
   }

   public function set currentLessonDevFolder(value:LessonDevFolder):void {
      _currentLessonDevFolder = value;
   }

   public function get currentLessonDevFolderList():ArrayCollection {
      return currentLessonLibrary.getLessonDevFolderList();
   }

   private var _lessonXML:XML;

   public function get lessonXML():XML {
      return _lessonXML;
   }

   private var _mostRecentScriptCheckSuccessful:Boolean;

   [Bindable(event="mostRecentScriptCheckSuccessfulChange")]
   public function get mostRecentScriptCheckSuccessful():Boolean {
      return _mostRecentScriptCheckSuccessful;
   }

   private var _resultsString:String;

   [Bindable(event="resultsStringChange")]
   public function get resultsString():String {
      return _resultsString;
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Public Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   public function MainModel(manager:SingletonManager) {
      _instance = this;
   }

   public function getDeployFolderPathForCurrentLessonDevFolder():String {
      if (!_currentLessonDevFolder)
         return null;
      if (!_currentLessonDevFolder.doesProblemFreeScriptFileExist())
         return null;
      var library:LessonLibrary = _index_lessonLibraryId_to_lessonLibrary[_currentLessonDevFolder.libraryId];
      if (!library) {
         ///// This generally happens because the libID in the script doesn't match this lib's ID - should be caught before this
         return null;
      }
      var languageFolderName:String = _currentLessonDevFolder.targetLanguageISO639_3Code;
      languageFolderName += (_currentLessonDevFolder.nativeLanguageISO639_3Code) ? "_" + _currentLessonDevFolder.nativeLanguageISO639_3Code : "";
      var folderPath:String = library.stagingFolderPath + File.separator + languageFolderName;
      return folderPath;
   }

   public static function getInstance():MainModel {
      if (!(_instance))
         throw new Error("Singleton not initialized");
      return _instance;
   }

   public function getLessonLibraryFromId(id:String):LessonLibrary {
      if (!_index_lessonLibraryId_to_lessonLibrary)
         return null;
      return _index_lessonLibraryId_to_lessonLibrary[id];
   }

   public static function init():MainModel {
      _instance.initConfigInfo();
      return _instance;
   }

   public function initSingleton():void {
   }

   /*public function processScriptCheck(script:String):void {
       script = Utils_String.removeWhiteSpaceIncludingLineReturnsFromBeginningOfString(script);
       script = _pinyinProcessor.convertNumberToneIndicatorsToToneMarks(script);
       _resultsString = _scriptAnalyzer.analyze(script);
       dispatchEvent(new Event("resultsStringChange"));
       applicationState = Constants_ApplicationState.APPLICATION_STATE__SCRIPT_CHECK_RESULTS;
       updateVoiceScriptsViewVisible(!_scriptAnalyzer.doProblemReportsExist());
       var success:Boolean;
       if (_scriptAnalyzer.doProblemReportsExist()) {
           success = false;
           _lessonXML = null;
           _voiceScriptsInfo = null;
       } else {
           success = true;
           _lessonXML = _scriptAnalyzer.createLessonXML();
           _voiceScriptsInfo = _scriptAnalyzer.createVoiceScriptsInfo();
           updateVoiceScriptsViewState(Constants_ApplicationState.VOICE_SCRIPTS_VIEW_STATE__INITIAL);
       }
       if (success != _mostRecentScriptCheckSuccessful) {
           _mostRecentScriptCheckSuccessful = success;
           dispatchEvent(new Event("mostRecentScriptCheckSuccessfulChange"));
       }
   }*/

   public function returnToPreviousApplicationState():void {
      applicationState = _applicationState_Previous;
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //          Private Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   private function initConfigInfo():void {
      var appDir:File = File.applicationDirectory;
      var f:File;
      var filePathString:String = "config.xml";
      f = appDir.resolvePath(filePathString);
      if (!f.exists) {
         Log.error("MainModel.initConfigInfo(): config file is missing");
         return;
      }
      var xml:XML = Utils_XML.synchronousLoadXML(f, true);
      if (!xml) {
         // Utils_XML.synchronousLoadXML() has already thrown an error
         return;
      }
      productionScriptFolderPath = xml.productionScriptFolder[0].toString();
      xmlConfigData_ContentRestrictions = xml.contentRestrictions[0]; // TODO - check for != 1 contentRestrictions node
      xmlConfigData_TargetLanguages = xml.targetLanguages[0]; // TODO - check for != 1 targetLanguages node
      initLessonLibraryInfoFromConfigData(xml.libraries[0]); // TODO - check for != 1 libraries node
      initVoiceTalentInfoFromConfigData(xml.voiceTalents[0]); // TODO - check for != 1 libraries node
      languageConfigInfo = new LanguageConfigInfo();
   }

   private function initLessonLibraryInfoFromConfigData(librariesXml:XML):void {
      lessonLibraryList = new ArrayCollection();
      var sort:Sort = new Sort();
      sort.fields = [new SortField("displayName")];
      lessonLibraryList.sort = sort;
      lessonLibraryList.refresh();
      _index_lessonLibraryId_to_lessonLibrary = new Dictionary();
      var libraryXmlList:XMLList = librariesXml.library;
      var library:LessonLibrary;
      for each (var libraryXml:XML in libraryXmlList) {
         library = new LessonLibrary();
         library.displayName = libraryXml.displayName[0].toString();
         library.lessonDevFolderPath = libraryXml.lessonDevFolderPath[0].toString();
         library.libraryId = libraryXml.id[0].toString();
         library.stagingFolderPath = libraryXml.stagingFolderPath[0].toString();
         library.init();
         lessonLibraryList.addItem(library);
         _index_lessonLibraryId_to_lessonLibrary[library.libraryId] = library;
      }
   }

   public function initVoiceTalentInfoFromConfigData(voiceTalentsXml:XML):void {
      voiceTalentList = new ArrayCollection();
      var voiceTalentXmlList:XMLList = voiceTalentsXml.voiceTalent;
      var voiceTalent:VoiceTalent;
      for each (var voiceTalentXml:XML in voiceTalentXmlList) {
         // displayFullPaymentDetail is optional - defaults to true;
         var displayFullPaymentDetail:Boolean = true;
         if (XMLList(voiceTalentXml.displayFullPaymentDetail).length() > 0) {
            displayFullPaymentDetail = Utils_XML.readBooleanNode(voiceTalentXml.displayFullPaymentDetail[0]);
         }
         voiceTalent = new VoiceTalent(
               voiceTalentXml.familyName[0].toString(),
               voiceTalentXml.givenName[0].toString(),
               voiceTalentXml.displayName[0].toString(),
               displayFullPaymentDetail,
               voiceTalentXml.paymentCurrency[0].toString(),
               Utils_XML.readNumberNode(voiceTalentXml.paymentPerOrderBaseRate[0]),
               Utils_XML.readNumberNode(voiceTalentXml.paymentPerUnitRate[0]));
         voiceTalentList.addItem(voiceTalent);
      }
   }


}
}
