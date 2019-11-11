/*
 *  Copyright 2018 Brightworks, Inc.
 *
 *  This file is part of Language Mentor.
 *
 *  Language Mentor is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Language Mentor is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Language Mentor.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 *
 *  TODO - Convert some or all of this info so that it resides in a config file? This might allow admins to add new languages, etc.
 *
 *
 *  The mission of this class is to hold all the language-specific info which we will need to edit when adding new
 *  languages.
 *
 */

package com.brightworks.lessoncreator.model {
import com.brightworks.lessoncreator.analyzers.*;
import com.brightworks.lessoncreator.constants.Constants_LineType;
import com.brightworks.util.Log;

import flash.utils.Dictionary;

public class LanguageConfigInfo {

   private static const _DEFAULT:String = "default";
   
   private var _index_lineTypeAnalyzers:Dictionary;

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //     Public Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   public function LanguageConfigInfo() {
      initLineAnalyzersIndex();
   }

   public function doesLanguageRequireUseOfPhoneticTargetLanguageLineInScript(targetLanguageISO639_3Code:String):Boolean {
      var result:Boolean = false;
      switch (targetLanguageISO639_3Code) {
         case "cmn":
            result = true;
            break;
         default:
            result = false;
      }
      return result;
   }

   public function getAllowedNonCommentChunkLineCount_Maximum(targetLanguageISO639_3Code:String):int {
      var result:int = 0;
      switch (targetLanguageISO639_3Code) {
         case "cmn":
            result = 4;
            break;
         default:
            result = 3;
      }
      return result;
   }

   public function getAllowedNonCommentChunkLineCount_Minimum(targetLanguageISO639_3Code:String):int {
      // So far, it seems that this would always be 2 //// but what about single-language lessons?
      return 1;
   }

   public function getChunkLineStyleName_Native(capitalize:Boolean = true):String {
      // TODO - Other native languages?
      return capitalize ? "English" : "English";
   }

   public function getChunkLineStyleName_Target(targetLanguageISO639_3Code:String, forceCapitalization:Boolean = true):String {
      var result:String = "";
      switch (targetLanguageISO639_3Code) {
         case "cmn":
            result = forceCapitalization ? "Hanzi" : "hanzi";
            break;
         case "deu":
            result = "German";
            break;
         case "eng":
            result = "English";
            break;
         case "esp":
            result = "Spanish";
            break;
         default:
            Log.error("LanguageConfigInfo.getChunkLineStyleName_Target(): No case for target language: " + targetLanguageISO639_3Code);
      }
      return result;
   }

   public function getChunkLineStyleName_TargetRomanized(targetLanguageISO639_3Code:String, forceCapitalization:Boolean):String {
      var result:String = "";
      switch (targetLanguageISO639_3Code) {
         case "cmn":
            result = forceCapitalization ? "Pinyin" : "pinyin";
            break;
         default:
            Log.error("LanguageConfigInfo.getChunkLineStyleName_TargetRomanized(): No case for target language: " + targetLanguageISO639_3Code);
      }
      return result;
   }

   // lineTypeId:       One of the 'id' constants in Constants_LineType.
   // targetLanguageId: Either an ISO 639-3 Code or null. When a null targetLanguageId gets passed in we default to
   //                   _DEFAULT as the target language ID. This can happen when we're looking for an analyzer for a line
   //                   type that can be analyzed without knowing the target language.
   //                   Example: The 'Author Name' line.
   //
   // TODO - Allow for the possibility that the native language will be something other than English. This will get a bit complex. Obviously, lines that contain native language will 'care' about this, but what about other kinds of lines? Role lines? Comment lines?
   //
   public function getLineAnalyzerInstanceForLineType(lineTypeId:String, targetLanguageId:String, scriptAnalyzer:Analyzer_Script):Analyzer_ScriptLine {
      if (!targetLanguageId) {
         targetLanguageId = _DEFAULT;
      }
      var lineTypeSpecificDictionary:Dictionary = _index_lineTypeAnalyzers[lineTypeId];
      if (!lineTypeSpecificDictionary) {
         Log.fatal("LanguageConfigInfo.getLineAnalyzerInstanceForLineType(): Class not specified for lineType/language - lineTypeID: " + lineTypeId + ", targetLanguageId: " + targetLanguageId);
         return null;
      }
      var clazz:Class = lineTypeSpecificDictionary[targetLanguageId];
      if (clazz is Class) {
         // A language-specific analyzer exists for this line type and we've found its class.
      } else {
         // No language-specific analyzer exists for this line type, so we use the line type's default analyzer.
         clazz = lineTypeSpecificDictionary[_DEFAULT];
      }
      if (!(clazz is Class)) {
         Log.fatal("LanguageConfigInfo.getLineAnalyzerInstanceForLineType(): Class not specified for lineType/language - lineTypeID: " + lineTypeId + ", targetLanguageId: " + targetLanguageId);
         return null;
      }
      var result:Analyzer_ScriptLine = new clazz(scriptAnalyzer);
      return result;
   }

   public function isNativeLanguageSupported(iso639_3Code:String):Boolean {
      var supportedLanguageList:Array = ["eng", "none"];
      return (supportedLanguageList.indexOf(iso639_3Code) != -1);
   }

   public function isTargetLanguageSupported(iso639_3Code:String):Boolean {
      var supportedLanguageList:Array = ["cmn", "deu", "esp"];
      return (supportedLanguageList.indexOf(iso639_3Code) != -1);
   }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   //
   //     Private Methods
   //
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   // lineTypeId:       One of the 'id' constants in Constants_LineType.
   // targetLanguageId: Either an ISO 639-3 Code or "default".  "default" is used to identify an analyzer that is used as a default, i.e.
   //                   when no language-specific analyzer is provided for a given language.
   // analyzerClazz:    The class that is used to analyze the specified type of line in the specified language.
   private function addEntryToLineAnalyzersIndex(lineTypeId:String, targetLanguageId:String, analyzerClazz:Class):void {
      var lineTypeSpecificDictionary:Dictionary = _index_lineTypeAnalyzers[lineTypeId];
      if (!lineTypeSpecificDictionary) {
         lineTypeSpecificDictionary = new Dictionary();
         _index_lineTypeAnalyzers[lineTypeId] = lineTypeSpecificDictionary;
      }
      var previouslyAddedLanguageId:String = lineTypeSpecificDictionary[targetLanguageId];
      if (previouslyAddedLanguageId) {
         Log.error("LanguageConfigInfo.addEntryToLineAnalyzersIndex(): Class already specified for lineType/language - lineTypeID: " + lineTypeId + ", languageID: " + targetLanguageId);
      } else {
         lineTypeSpecificDictionary[targetLanguageId] = analyzerClazz;
      }
   }

   private function initLineAnalyzersIndex():void {
      _index_lineTypeAnalyzers = new Dictionary();
      addEntryToLineAnalyzersIndex(Constants_LineType.LINE_TYPE_ID__CHUNK__NATIVE_LANGUAGE,            _DEFAULT, Analyzer_ScriptLine_Chunk_NativeLanguage);
      addEntryToLineAnalyzersIndex(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE,            _DEFAULT, Analyzer_ScriptLine_Chunk_TargetLanguage);
      addEntryToLineAnalyzersIndex(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE,            "cmn",    Analyzer_ScriptLine_Chunk_TargetLanguage_CMN);
      addEntryToLineAnalyzersIndex(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC,  _DEFAULT, Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic);
      addEntryToLineAnalyzersIndex(Constants_LineType.LINE_TYPE_ID__CHUNK__TARGET_LANGUAGE__PHONETIC,  "cmn",    Analyzer_ScriptLine_Chunk_TargetLanguage_Phonetic_CMN);
   }
}
}
