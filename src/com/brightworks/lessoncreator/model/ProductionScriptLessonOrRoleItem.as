package com.brightworks.lessoncreator.model {
   import com.brightworks.interfaces.ISelectable;
   import com.brightworks.lessoncreator.model.LessonDevFolder;

   public class ProductionScriptLessonOrRoleItem implements ISelectable {
      public var lessonDevFolder:LessonDevFolder;
      public var roleName:String;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private var _isLessonScriptHasProblems:Boolean;

      public function get isLessonScriptHasProblems():Boolean {
         return !lessonDevFolder.doesProblemFreeScriptFileExist();
      }

      private var _isSelectable:Boolean;

      public function get isSelectable():Boolean {
         return !isLessonScriptHasProblems;
      }

      private var _isSelected:Boolean;

      public function get isSelected():Boolean {
         return _isSelected;
      }

      public function set isSelected(value:Boolean):void {
         _isSelected = value;
      }

      public function get lessonId():String {
         if (lessonDevFolder) {
            return lessonDevFolder.lessonId;
         } else {
            return null;
         }
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function ProductionScriptLessonOrRoleItem() {
      }
   }
}
