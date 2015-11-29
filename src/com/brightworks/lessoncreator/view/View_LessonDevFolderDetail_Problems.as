package com.brightworks.lessoncreator.view {
   import com.brightworks.lessoncreator.constants.Constants_Misc;
   import com.brightworks.lessoncreator.model.LessonDevFolder;
   import com.brightworks.lessoncreator.problems.LessonProblem;
   import com.brightworks.lessoncreator.model.MainModel;
   import com.brightworks.util.Utils_File;
   import com.brightworks.util.Utils_XML;

   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filesystem.File;

   import flashx.textLayout.conversion.TextConverter;

   import mx.collections.ArrayCollection;
   import mx.controls.Spacer;

   import spark.components.Alert;
   import spark.components.DataGrid;
   import spark.components.Label;
   import spark.components.TextArea;
   import spark.components.gridClasses.GridColumn;
   import spark.events.GridSelectionEvent;

   public class View_LessonDevFolderDetail_Problems extends ViewBase {

      private static const _HOW_TO_FIX_LINE:String = "<p><bold>How to fix:</bold></p>";

      private var _explanationLabel:Label;
      private var _isCreateChildrenCalled:Boolean;
      private var _problemDataGrid:DataGrid;
      private var _problemDetailTextArea:TextArea;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      [Bindable]
      private var _problemList:ArrayCollection = new ArrayCollection();

      public function set problemList(value:ArrayCollection):void {
         _problemList.removeAll();
         for each (var problem:LessonProblem in value) {
            _problemList.addItem(problem);
         }
         setExplanationLabelText();
         var s:String = _HOW_TO_FIX_LINE + "<p/><p>Select a problem in the list above to see suggestions on how to fix the problem.</p>"
         _problemDetailTextArea.textFlow = TextConverter.importToFlow(s, TextConverter.TEXT_FIELD_HTML_FORMAT);
         invalidateDisplayList();
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function View_LessonDevFolderDetail_Problems() {
         super();
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Protected Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      override protected function createChildren():void {
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
         addElement(new Spacer());
         _explanationLabel = new Label();
         _explanationLabel.setStyle("fontSize", 16);
         addElement(_explanationLabel);
         addElement(new Spacer());
         _problemDataGrid = new DataGrid();
         _problemDataGrid.percentWidth = 100;
         _problemDataGrid.dataProvider = _problemList;
         _problemDataGrid.addEventListener(GridSelectionEvent.SELECTION_CHANGE, onProblemDataGridSelectionChange);
         var columns:ArrayCollection = new ArrayCollection();
         var column:GridColumn;
         column = new GridColumn();
         column.headerText = "Problems";
         column.dataField = "humanReadableProblemDescription";
         columns.addItem(column);
         column = new GridColumn();
         column.headerText = "Location";
         column.labelFunction = labelFunction_LocationColumn;
         columns.addItem(column);
         _problemDataGrid.columns = columns;
         addElement(_problemDataGrid);
         addElement(new Spacer());
         _problemDetailTextArea = new TextArea();
         _problemDetailTextArea.heightInLines = 8;
         _problemDetailTextArea.percentWidth = 100;
         _problemDetailTextArea.setStyle("borderVisible", false);
         addElement(_problemDetailTextArea);

      /*var button:Button = new Button();
      button.label = "Fix";
      button.addEventListener(MouseEvent.CLICK, onFixButtonClick);
      addElement(button);*/
      }

      protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
         super.updateDisplayList(unscaledWidth, unscaledHeight);
         // TODO - fix kludgy approach to setting problem data grid scroll position to top when refreshing data
         // probably breaks when resizing window, etc - need to (at least) run this code when
         // app height changes
         var gridRowCount:uint = computeProblemDataGridRowCount();
         if (gridRowCount != _problemDataGrid.requestedRowCount) {
            _problemDataGrid.requestedRowCount = gridRowCount;
            _problemDataGrid.scroller.verticalScrollBar.value = _problemDataGrid.scroller.verticalScrollBar.minimum;
         }
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Private Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      private function computeProblemDataGridRowCount():uint {
         var maxCount:uint = Math.floor((height - 200) / _problemDataGrid.rowHeight);
         var result:uint = Math.min(_problemList.length, maxCount);
         return result;
      }

      private function labelFunction_LocationColumn(data:Object, gridColumn:GridColumn):String {
         var problem:LessonProblem = LessonProblem(data);
         if ((problem.isScriptLineSpecificProblem) ||
            (problem.problemType == LessonProblem.PROBLEM_TYPE__SCRIPT__INDETERMINATE_LINE_TYPE)) {
            return "Script - line " + problem.lineNumber;
         } else if (problem.isScriptChunkSpecificProblem) {
            return "Script - chunk " + problem.chunkNumber + " - lines " + problem.chunkLineNumber_FirstLine + "-" + problem.chunkLineNumber_LastLine;
         }
         return "";
      }

      private function onFixButtonClick(event:MouseEvent):void {
         var model:MainModel = MainModel.getInstance();
         var lessonDevFolder:LessonDevFolder = model.currentLessonDevFolder;
         if (lessonDevFolder.getSubfolder_credits()) {
            Alert.show("Folder already exists");
            return;
         }
         var creditsFolder:File = lessonDevFolder.folder.resolvePath("credits");
         creditsFolder.createDirectory();
         var xmlFolder:File = lessonDevFolder.getSubfolder_xml();
         var xmlFile:File = xmlFolder.resolvePath(lessonDevFolder.lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_XML_FILE);
         if (!xmlFile.exists) {
            Alert.show("No XML file");
            return;
         }
         var xml:XML = Utils_XML.synchronousLoadXML(xmlFile, false);
         if (!xml) {
            Alert.show("XML parsing error - no credits file created");
            return;
         }
         if (XMLList(xml.credits).length() == 0) {
            Alert.show("XML does not contain a credits node - no credits file created");
            return;
         }
         if (XMLList(xml.credits).length() > 1) {
            Alert.show("XML contains more than one credits node - no credits file created");
            return;
         }
         var xmlString:String = XML(xml.credits[0]).toXMLString();
         var creditsFile:File = creditsFolder.resolvePath(lessonDevFolder.lessonId + "." + Constants_Misc.FILE_NAME_EXTENSION__LESSON_CREDITS_FILE);
         Utils_File.writeTextFile(creditsFile, xmlString);
         Alert.show("Success");


      }

      private function onProblemDataGridSelectionChange(event:Event):void {
         if (_problemDataGrid.selectedItem)
            _problemDetailTextArea.text = LessonProblem(_problemDataGrid.selectedItem).humanReadableFixDescription;
         else
            _problemDetailTextArea.text = "";
      }

      private function setExplanationLabelText():void {
         _explanationLabel.text = "Please correct the problems listed below"
      }


   }
}
