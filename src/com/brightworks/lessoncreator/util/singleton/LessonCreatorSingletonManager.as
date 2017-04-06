package com.brightworks.lessoncreator.util.singleton {
   import com.brightworks.lessoncreator.model.MainModel;
   import com.brightworks.util.Log;
   import com.brightworks.util.PerformanceAnalyzer;
   import com.brightworks.util.Utils_DateTime;
   import com.brightworks.util.singleton.SingletonManager;

   public class LessonCreatorSingletonManager extends SingletonManager {
      public function LessonCreatorSingletonManager() {
         super();
      }

      override protected function populateClassList():void {
         singletonClassList = [
            Log,
            Utils_DateTime,
            MainModel,
            PerformanceAnalyzer
         ]
      }
   }
}
