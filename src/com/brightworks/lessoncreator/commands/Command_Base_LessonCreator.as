package com.brightworks.lessoncreator.commands {
   import com.brightworks.controller.Command_Base;
   import com.brightworks.lessoncreator.model.MainModel;
   import com.brightworks.util.Log;

   public class Command_Base_LessonCreator extends Command_Base {
      protected var model:MainModel = MainModel.getInstance();

      private var _isDisposed:Boolean = false;

      public function Command_Base_LessonCreator() {
         super();
      }

      override public function dispose():void {
         Log.debug("Command_Base_LessonCreator.dispose()");
         super.dispose();
         if (_isDisposed)
            return;
         _isDisposed = true;
         model = null;
      }


   }
}
