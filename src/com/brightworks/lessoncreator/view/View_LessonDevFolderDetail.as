package com.brightworks.lessoncreator.view {

import com.brightworks.base.Callbacks;
import com.brightworks.lessoncreator.commands.Command_DeployLesson;
import com.brightworks.lessoncreator.model.LessonDevFolder;
import com.brightworks.util.Log;
import com.brightworks.util.Utils_ArrayVectorEtc;

import flash.events.Event;
   import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mx.controls.Spacer;
   import mx.containers.ViewStack;
   import mx.core.INavigatorContent;
   import mx.core.UIComponent;

import spark.components.Alert;

import spark.components.Button;

   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.NavigatorContent;

   public class View_LessonDevFolderDetail extends ViewBase {

      private var _button_DeployLesson:Button;
      private var _button_Refresh:Button;
      private var _currentActiveDeployLessonCommands:Dictionary = new Dictionary();
      private var _footer:HGroup;
      private var _header:HGroup;
      private var _headerCenterSpacer:Spacer;
      private var _titleLabel_Left:Label;
      private var _titleLabel_Right:Label;
      private var _topButtonBar:HGroup;
      private var _view_Problems:View_LessonDevFolderDetail_Problems;
      private var _view_Standard:View_LessonDevFolderDetail_Standard;
      private var _viewStack:ViewStack;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private var _lessonDevFolder:LessonDevFolder;
      private var _lessonDevFolderChanged:Boolean;

      public function set lessonDevFolder(value:LessonDevFolder):void {
         if (value != _lessonDevFolder) {
            _lessonDevFolder = value;
            _lessonDevFolderChanged = true;
            invalidateProperties();
         }
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function View_LessonDevFolderDetail() {
         super();
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Protected Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      override protected function commitProperties():void {
         super.commitProperties();
         if (_lessonDevFolderChanged) {
            _lessonDevFolderChanged = false;
            updateUI();
         }
      }

      override protected function createChildren():void {
         super.createChildren();
         _header = new HGroup();
         _header.percentWidth = 100;
         _header.verticalAlign = "bottom";
         addElement(_header);
         _titleLabel_Left = new Label();
         _titleLabel_Left.setStyle("fontSize", 20);
         _titleLabel_Left.setStyle("fontWeight", "bold");
         _header.addElement(_titleLabel_Left);
         _headerCenterSpacer = new Spacer();
         _headerCenterSpacer.percentWidth = 100;
         _header.addElement(_headerCenterSpacer);
         _titleLabel_Right = new Label();
         _titleLabel_Right.setStyle("fontSize", 16);
         _titleLabel_Right.setStyle("fontWeight", "bold");
         _header.addElement(_titleLabel_Right);
         addElement(new Spacer());
         _topButtonBar = new HGroup();
         addElement(_topButtonBar);
         _button_Refresh = new Button();
         _button_Refresh.label = "Refresh";
         _button_Refresh.addEventListener(MouseEvent.CLICK, onRefreshButtonClick);
         _button_Refresh.visible = false;
         _button_Refresh.includeInLayout = false;
         _topButtonBar.addElement(_button_Refresh);
         _button_DeployLesson = new Button();
         _button_DeployLesson.label = "Deploy Lesson";
         _button_DeployLesson.addEventListener(MouseEvent.CLICK, onDeployLessonButtonClick);
         _button_DeployLesson.visible = false;
         _button_DeployLesson.includeInLayout = false;
         _topButtonBar.addElement(_button_DeployLesson);
         var spacer:Spacer = new Spacer();
         spacer.height = 20;
         addElement(spacer);
         _viewStack = new ViewStack();
         _viewStack.percentHeight = 100;
         _viewStack.percentWidth = 100;
         addElement(_viewStack);
         _view_Standard = new View_LessonDevFolderDetail_Standard();
         addViewToViewStack(_view_Standard);
         _view_Problems = new View_LessonDevFolderDetail_Problems();
         addViewToViewStack(_view_Problems);
         _footer = new HGroup();
         _footer.percentWidth = 100;
         addElement(_footer);
         addElement(new Spacer());
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private function addViewToViewStack(view:UIComponent):void {
         var navigatorContent:NavigatorContent = new NavigatorContent();
         navigatorContent.percentHeight = 100;
         navigatorContent.percentWidth = 100;
         view.percentHeight = 100;
         view.percentWidth = 100;
         navigatorContent.addElement(view);
         _viewStack.addChild(navigatorContent);
      }

      private function getNavigatorContentWrapperFromView(view:UIComponent):INavigatorContent {
         var result:INavigatorContent;
         while (true) {
            if (view.parent is UIComponent) {
               if (view.parent is INavigatorContent) {
                  result = INavigatorContent(view.parent);
                  break;
               } else {
                  view = UIComponent(view.parent);
               }
            } else {
               break;
            }
         }
         return result;
      }

      private function onDeployLessonButtonClick(event:Event):void {
          var command:Command_DeployLesson = new Command_DeployLesson(_lessonDevFolder, new Callbacks(onDeployLessonCommandComplete, onDeployLessonCommandFailure));
          _currentActiveDeployLessonCommands[_lessonDevFolder] = command;
          command.execute();
      }

      private function onDeployLessonCommandComplete(command:Command_DeployLesson):void {
         delete _currentActiveDeployLessonCommands[command.lessonDevFolder];
      }

      private function onDeployLessonCommandFailure(command:Command_DeployLesson):void {
         // TODO - handle in a more user-friendly way - reason for failure, etc.
         Alert.show("Deploy Lesson failed: " + command.lessonDevFolder.lessonId);
         delete _currentActiveDeployLessonCommands[command.lessonDevFolder];
      }

      private function onRefreshButtonClick(event:MouseEvent):void {
         _lessonDevFolder.refresh();
         updateUI();
      }

      private function updateUI():void {
         _button_DeployLesson.visible = false;
         _button_DeployLesson.includeInLayout = false;
         _button_Refresh.visible = false;
         _button_Refresh.includeInLayout = false;
         _titleLabel_Left.text = "";
         _titleLabel_Right.text = "";
         if (_lessonDevFolder) {
            _titleLabel_Left.text = _lessonDevFolder.lessonId;
            _titleLabel_Right.text = "Release Type: " + _lessonDevFolder.releaseType;
            _button_Refresh.visible = true;
            _button_Refresh.includeInLayout = true;
            if (_lessonDevFolder.getLessonProblemList().length == 0) {
               _button_DeployLesson.visible = true;
               _button_DeployLesson.includeInLayout = true;
               _viewStack.selectedChild = getNavigatorContentWrapperFromView(_view_Standard);
               _view_Standard.lessonDevFolder = _lessonDevFolder;
            } else {
               _viewStack.selectedChild = getNavigatorContentWrapperFromView(_view_Problems);
               _view_Problems.problemList = _lessonDevFolder.getLessonProblemList();
            }
         }
      }

   }
}
