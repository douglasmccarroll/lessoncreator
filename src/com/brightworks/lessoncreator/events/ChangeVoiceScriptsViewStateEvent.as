package com.brightworks.lessoncreator.events
{
    import flash.events.Event;

    public class ChangeVoiceScriptsViewStateEvent extends Event
    {
        public static const CHANGE_VOICE_SCRIPTS_VIEW_STATE:String = "changeVoiceScriptsViewStateEvent_ChangeVoiceScriptsViewState";
        
        public var newState:String;
        
        public function ChangeVoiceScriptsViewStateEvent(type:String)
        {
            super(type, true);
        }
    }
}