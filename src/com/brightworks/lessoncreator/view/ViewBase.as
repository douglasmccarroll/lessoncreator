package com.brightworks.lessoncreator.view
{
    import flash.events.Event;

import mx.binding.utils.BindingUtils;

import mx.binding.utils.ChangeWatcher;
    
    import spark.components.Group;
import spark.components.VGroup;

public class ViewBase extends VGroup
    {
        import com.brightworks.lessoncreator.model.MainModel;
        
        [Bindable (event="modelChange")]
        protected var model:MainModel;

        private var _watcher_applicationState:ChangeWatcher;

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        //
        //          Public Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        public function ViewBase()
        {
            super();
            percentHeight = 100;
            percentWidth = 100;
            model = MainModel.getInstance();
            _watcher_applicationState = BindingUtils.bindSetter(onApplicationStateChange, model, "applicationState");
        }
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //
        //          Protected Methods
        //
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        protected function onApplicationStateChange(newValue:String):void
        {
            // We do nothing here - this method can be overridden by subclasses
            // so that they can know when they become the active state, or, not.
        }
        
    }
}