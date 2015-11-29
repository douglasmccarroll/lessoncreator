package com.brightworks.lessoncreator.model {
   import flash.filesystem.File;

   import mx.collections.ArrayCollection;

   public class LessonDevWorkspace {
      public var folderPath:String;
      public var displayName:String;

      private var _folder:File;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function LessonDevWorkspace() {
      }

      public function getLessonDevFolderList():ArrayCollection {
         var result:ArrayCollection = new ArrayCollection();
         for each (var f:File in _folder.getDirectoryListing()) {
            if (f.isDirectory) {
               var lessonDevFolder:LessonDevFolder = new LessonDevFolder(f);
               if (lessonDevFolder.doesFolderContainScriptFolder())
                  result.addItem(lessonDevFolder);
            }
         }
         return result;
      }

      public function init():void {
         _folder = new File();
         _folder.nativePath = folderPath;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


   }
}
