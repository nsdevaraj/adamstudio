/*
* Copyright 2010 @nsdevaraj
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package com.adams.swizdao.util
{
	public final class Action
	{
		public static const CREATE:String = 'create';
		public static const UPDATE:String = 'update';
		public static const DIRECTUPDATE:String = 'directupdate';
		public static const READ:String = 'Read';
		public static const READMAX:String = 'findMaxTaskId';
		public static const FIND_ID:String = 'findId';
		public static const FINDBY_NAME:String = 'findByName';
		public static const FINDBY_ID:String = 'findById';
		public static const FINDPUSH_ID:String = 'FindPushId';
		public static const DELETE:String = 'deleteById';
		public static const GET_COUNT:String = 'count';
		public static const GET_LIST:String = 'getList';
		public static const ADD_LIST:String = 'getaddList';
		public static const SQL_FINDALL:String = 'SQLFindAll';
		public static const BULK_UPDATE:String = 'bulkUpdate';
		public static const DELETE_ALL:String = 'deleteAll';
		public static const PUSH_MSG:String = 'PushMsg';
		public static const RECEIVE_MSG:String = 'receiveMsg';
		public static const FINDTASKSLIST:String = 'findTasksList';
		
		public static const URL_REQUEST:String = 'url_request';
		public static const PROCESS_URL_REQUEST:String = 'process_url_request';
		public static const HTTP_REQUEST:String = 'http_request';
		public static const E4X_REQUEST:String = 'e4x_request';
		public static const PAGINATIONQUERY:String = 'findPersonsListOracle';
		public static const REFRESHQUERY:String = 'findByDate';
		public static const GETQUERYRESULT:String = 'getQueryResult';
		public static const PAGINATIONLISTVIEW:String = 'paginationListView';
		public static const BULKUPDATEPROJECTPROPERTIES:String = 'createProjectProperties';
		public static const QUERYLISTVIEW:String = 'queryListView';
		public static const PAGINATIONLISTVIEWID:String = 'paginationListViewId';
		public static const QUERYPAGINATION:String = 'queryPagination';
		public static const GETLOGINLISTRESULT:String = 'getLoginListResult';
		public static const CREATEPROJECT:String = 'createOracleNewProject';
		public static const CREATENAVTASK:String = 'createNavigationTasks';
		public static const GETPROJECTSLIST:String = 'findPersonsListCount';
		public static const FILEDELETE:String = 'deleteFile';
		public static const FILECONVERT:String = 'doConvert';
		public static const FILEDOWNLOAD:String = 'downLoadFile';
		public static const FILEMOVE:String = 'copyDirectory';
		public static const CLOSEPROJECT:String = 'closeProjects';
		public static const STAND_RESUMEPROJECT:String = 'projectStatusChangeTask';
		
		public static const UPDATETWEET:String = 'updateTweet';
		public static const SENDMAIL:String = 'sendMail';
		public static const CREATEPERSON:String = 'createPerson';
		public static const GETSESSIONJAVA:String = 'javaGetCurrentSession';		
		public static const PDFCONVERTIONJAVA:String = 'javaPdfConvertion';
		public static const EXCELCONVERTIONJAVA:String = 'javaExcelConvertion';
		public static const PAGINGACTIONS:Array = [FILEDOWNLOAD,BULKUPDATEPROJECTPROPERTIES,GETQUERYRESULT,GET_COUNT,REFRESHQUERY,
			GETPROJECTSLIST,PAGINATIONLISTVIEW,QUERYLISTVIEW,PAGINATIONLISTVIEWID,QUERYPAGINATION,GETLOGINLISTRESULT,
			UPDATETWEET,SENDMAIL,CREATEPERSON,PDFCONVERTIONJAVA,EXCELCONVERTIONJAVA,GETSESSIONJAVA,URL_REQUEST];
	}
}
