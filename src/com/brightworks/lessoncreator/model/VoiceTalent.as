package com.brightworks.lessoncreator.model {
import com.brightworks.util.Utils_XML;

import flash.net.registerClassAlias;

   public class VoiceTalent {
      public var name_Display:String;
      public var name_Family:String;
      public var name_Given:String;
      public var displayFullPaymentDetail:Boolean;
      public var paymentCurrency:String;
      public var paymentPerOrderMinimum:Number;
      public var paymentPerUnitRate:Number;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Getters / Setters
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function get name_Display__FamilyCommaSpaceGiven():String {
         return name_Family + ", " + name_Given;
      }

      private var _paymentPerOrderBaseRate:Number;

      public function get paymentPerOrderBaseRate():Number {
         // Round upward to next whole number
         return Math.ceil(_paymentPerOrderBaseRate);
      }

      public function set paymentPerOrderBaseRate(value:Number):void {
         _paymentPerOrderBaseRate = value;
      }

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      //
      //     Public Methods
      //
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      public function VoiceTalent(
         name_Family:String,
         name_Given:String,
         name_Display:String,
         displayFullPaymentDetail:Boolean,
         paymentCurrency:String,
         paymentPerOrderBaseRate:Number,
         paymentPerOrderMinimum:Number,
         paymentPerUnitRate:Number) {
         this.displayFullPaymentDetail = displayFullPaymentDetail;
         this.name_Display = name_Display;
         this.name_Family = name_Family;
         this.name_Given = name_Given;
         this.paymentCurrency = paymentCurrency;
         this.paymentPerOrderBaseRate = paymentPerOrderBaseRate;
         this.paymentPerOrderMinimum = paymentPerOrderMinimum;
         this.paymentPerUnitRate = paymentPerUnitRate;
      }
   }
}
