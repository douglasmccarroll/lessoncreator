package com.brightworks.lessoncreator.model {
import flash.filesystem.File;

import mx.collections.ArrayCollection;

public class LessonLibrary {

    public var displayName:String;
    public var lessonDevFolderPath:String;
    public var libraryId:String;
    public var stagingFolderPath:String;

    private var _lessonDevFolder:File;

    public function LessonLibrary() {
    }

    public function getLessonDevFolderList():ArrayCollection {
        var result:ArrayCollection = new ArrayCollection();
        for each (var f:File in _lessonDevFolder.getDirectoryListing()) {
            if (f.isDirectory) {
                var lessonDevFolder:LessonDevFolder = new LessonDevFolder(f);
                if (lessonDevFolder.doesFolderContainScriptFolder())
                    result.addItem(lessonDevFolder);
            }
        }
        return result;

    }

    public function init():void {
        _lessonDevFolder = new File();
        _lessonDevFolder.nativePath = lessonDevFolderPath;
    }
}
}
