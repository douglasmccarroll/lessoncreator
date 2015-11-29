package com.brightworks.lessoncreator.commands {
import com.brightworks.base.Callbacks;
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_File;
import com.brightworks.util.Utils_XML;

import flash.filesystem.File;

public class Command_DeployLesson extends Command_Base_LessonCreator {
      private var _isDisposed:Boolean = false;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private var _lessonDevFolder:LessonDevFolder;

      public function get lessonDevFolder():LessonDevFolder {
         return _lessonDevFolder;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function Command_DeployLesson(lessonDevFolder:LessonDevFolder, callbacks:Callbacks) {
         super();
         this.callbacks = callbacks;
         _lessonDevFolder = lessonDevFolder;
      }

      override public function dispose():void {
         Log.debug("Command_DeployLesson.dispose()");
         super.dispose();
         if (_isDisposed)
            return;
         _isDisposed = true;
         _lessonDevFolder = null;
      }

      public function execute():void {
         if (!_lessonDevFolder.doesProblemFreeScriptFileExist())
            fault(this);
         var lessonXml:XML = _lessonDevFolder.lessonXml;
         var filePath:String = model.getDeployFolderPathForCurrentLessonDevFolder() + File.separator + _lessonDevFolder.lessonId + ".xml";
         var newFile:File = new File();
         newFile.nativePath = filePath;
         Utils_File.writeTextFile(newFile, lessonXml.toString());
         result(this);
      }

   }
}
