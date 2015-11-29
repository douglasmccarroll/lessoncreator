package com.brightworks.lessoncreator.view {
   import com.brightworks.lessoncreator.model.LessonDevFolder;

   import flash.events.Event;
   import flash.events.MouseEvent;

import mx.controls.Spacer;

import spark.components.Button;
import spark.components.HGroup;
import spark.components.VGroup;

   public class View_LessonDevFolderDetail_Standard extends ViewBase {

      public var lessonDevFolder:LessonDevFolder;

      private var _isCreateChildrenCalled:Boolean;

      public function View_LessonDevFolderDetail_Standard() {
         super();
      }

      protected override function createChildren():void {
         if (_isCreateChildrenCalled) {
            // dmccarroll 20140416
            // For some reason, this method is getting called twice. Which is Very Wrong. I suspect that it has something
            // to do with the fact that I'm wrapping this view in a NavigatorContent. Which I'm doing so that I can use
            // this Spark class within an MX ViewStack. Wrapping in NavigatorContent is standard practice, and isn't
            // causing any problem when I do it in MXML. Perhaps the fact that I'm having a problem here is due to the
            // fact that I'm using ActionScript to do the wrapping in this case.
            return;
         }
         _isCreateChildrenCalled = true;
         super.createChildren();
      }

   }
}
