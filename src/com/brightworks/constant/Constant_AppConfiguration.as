/*
Copyright 2018 Brightworks, Inc.

This file is part of Language Mentor.

Language Mentor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Language Mentor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Language Mentor.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.brightworks.constant {
import com.brightworks.util.Log;

public class Constant_AppConfiguration {

   // Default config info is used a) when config info has not yet been loaded from 'mentor type' file, and b) ? If there is a problem loading this data?
   public static const DEFAULT_CONFIG_INFO__LOG_LEVEL__INTERNAL_LOGGING:uint = Log.LOG_LEVEL__INFO;
   public static const DEFAULT_CONFIG_INFO__LOG_LEVEL__LOG_TO_SERVER:uint = Log.LOG_LEVEL__WARN;
   public static const DEFAULT_CONFIG_INFO__LOG_TO_SERVER_MAX_STRING_LENGTH:uint = 8000;
   public static const DEFAULT_CONFIG_INFO__LOG_URL:String = "https://31t88tqyx8.execute-api.us-east-1.amazonaws.com/prod/log-message";

}
}
