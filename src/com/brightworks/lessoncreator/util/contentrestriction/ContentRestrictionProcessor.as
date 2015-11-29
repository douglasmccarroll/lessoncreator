package com.brightworks.lessoncreator.util.contentrestriction {
   import com.brightworks.lessoncreator.model.MainModel;
   import com.brightworks.util.Log;
   import com.brightworks.util.Utils_String;
import com.brightworks.util.Utils_XML;

public class ContentRestrictionProcessor {
      private static var _contentRestrictionList:Array;

      public function ContentRestrictionProcessor() {
      }

      public static function getListOfRestrictedContentContainedInString(s:String):Array {
         loadContentRestrictionList();
         var result:Array = [];
         for each (var contentRestriction:ContentRestriction in _contentRestrictionList) {

            // For debugging
            /*var restrictedString:String = "wu3 ge";
            if (s.indexOf(restrictedString) != -1)
               var foo:int = 0;
            if ((s.indexOf(restrictedString) != -1) && (contentRestriction.restrictedContent == restrictedString))
               var bar:int = 0;*/


            var matchIndexList:Array = Utils_String.getListOfIndexesOfAllMatchesForSubstring(s, contentRestriction.restrictedContent, contentRestriction.caseSensitive);
            for each (var matchIndex:uint in matchIndexList) {
               var isAMatch:Boolean = true;
               var precedingCharIndex:int = matchIndex - 1; // Note that this may be -1, meaning 'no previous char'
               var followingCharIndex:int = matchIndex + contentRestriction.restrictedContent.length;
               if (followingCharIndex >= s.length)
                  followingCharIndex = -1; // i.e. 'no following char'
               switch (contentRestriction.precededBy) {
                  case ContentRestriction.SURROUNDING_CONTENT_TYPE__ANY:
                     // Anything goes - it's a match
                     break;
                  case ContentRestriction.SURROUNDING_CONTENT_TYPE__WHITE_SPACE_AND_PUNCTUATION:
                     if (precedingCharIndex == -1) {
                        // No preceding char, so preceding char is a line break, and we count line breaks as white space, thus this is a match condition
                     } else if (!Utils_String.isCharAtIndexLineBreak_WhiteSpace_Or_Punctuation(s, precedingCharIndex)) {
                        isAMatch = false;
                     }
                     break;
                  default:
                     Log.error("ContentRestrictionProcessor.getListOfRestrictedContentContainedInString(): No case for " + contentRestriction.precededBy);
               }
               if (!isAMatch)
                  continue;
               switch (contentRestriction.followedBy) {
                  case ContentRestriction.SURROUNDING_CONTENT_TYPE__ANY:
                     // Anything goes - it's a match
                     break;
                  case ContentRestriction.SURROUNDING_CONTENT_TYPE__WHITE_SPACE_AND_PUNCTUATION:
                     if (followingCharIndex == -1) {
                        // No following char, so following char is a line break, and we count line breaks as white space, thus this is a match condition
                     } else if (!Utils_String.isCharAtIndexLineBreak_WhiteSpace_Or_Punctuation(s, followingCharIndex)) {
                        isAMatch = false;
                     }
                     break;
                  default:
                     Log.error("ContentRestrictionProcessor.getListOfRestrictedContentContainedInString(): No case for " + contentRestriction.precededBy);
               }
               if (isAMatch) {
                  result.push(contentRestriction);
                  break; // i.e. don't check all matched of this restriction within the string - one match suffices
               }
            }
         }
         return result;
      }

      // TODO - much room for improvement here - check config XML first, report problems to user and, probably, enhancements to content restrictions in general
      private static function loadContentRestrictionList():void {
         if (_contentRestrictionList is Array)
            return;
         _contentRestrictionList = [];
         var restrictionList:XMLList = MainModel.getInstance().xmlConfigData_ContentRestrictions.restriction;
         for each (var restrictionXml:XML in restrictionList) {
            var contentRestriction:ContentRestriction = new ContentRestriction();
            contentRestriction.restrictedContent = XML(restrictionXml.content[0]).toString();
            var caseSensitive:Boolean = false;
            var precededBy:String = ContentRestriction.SURROUNDING_CONTENT_TYPE__WHITE_SPACE_AND_PUNCTUATION;
            var followedBy:String = ContentRestriction.SURROUNDING_CONTENT_TYPE__WHITE_SPACE_AND_PUNCTUATION;
            if (XMLList(restrictionXml.caseSensitive).length() > 0) {
               caseSensitive = Utils_XML.readBooleanNode(restrictionXml.caseSensitive[0]);
            }
            if (XMLList(restrictionXml.precededBy).length() > 0) {
               var precededByFromXml:String = restrictionXml.precededBy[0].toString();
               switch (precededByFromXml) {
                  case "any":
                     precededBy = ContentRestriction.SURROUNDING_CONTENT_TYPE__ANY;
                     break;
                  default:
                     Log.warn("ContentRestrictionProcessor.loadContentRestrictionList(): Content restriction XML has unknown precededBy value: " + precededBy);
               }
            }
            if (XMLList(restrictionXml.followedBy).length() > 0) {
               var followedByFromXml:String = restrictionXml.followedBy[0].toString();
               switch (followedByFromXml) {
                  case "any":
                     followedBy = ContentRestriction.SURROUNDING_CONTENT_TYPE__ANY;
                     break;
                  default:
                     Log.warn("ContentRestrictionProcessor.loadContentRestrictionList(): Content restriction XML has unknown followedBy value: " + followedBy);
               }
            }
            contentRestriction.caseSensitive = caseSensitive;
            contentRestriction.precededBy = precededBy;
            contentRestriction.followedBy = followedBy;
            _contentRestrictionList.push(contentRestriction);
         }

      }
   }
}
