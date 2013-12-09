/**
 * BlogService
 * 
 * This class encapsulates the interface between the Flex UI and the server, written in PHP. This
 * class extends HTTPService, specifically the MXML version, so it can be included as a tag in
 * the main application.
 */
package com.adams.blog.service
{
	import com.adams.blog.data.Article;
	import com.adams.blog.data.BlogLink;
	import com.adams.blog.data.Category;
	import com.adams.blog.data.NewsHeadline;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	[Event(name="articlesReady")]
	
	public class BlogService extends HTTPService
	{
		/**
		 * constructor
		 * 
		 * Sets the result format, concurrency, and event listeners.
		 */
		public function BlogService()
		{
			super();
			
			resultFormat = "e4x";
			concurrency = "multiple";
			
			addEventListener( ResultEvent.RESULT, handleResult );
			addEventListener( FaultEvent.FAULT, handleFault );
		}
		
		/*
		 *
		 */
		
		/**
		 * handleFault
		 * 
		 * If the HTTP request generates a fault somehow, that string is simply printed to the
		 * debug log. A better solution should be done here.
		 */
		private function handleFault( event:FaultEvent ) : void
		{
			trace("Fault: "+event.fault.faultString);
		}
		
		/**
		 * handleResult
		 * 
		 * When a valid result (ie, XML) comes back, the root node is used to determine the
		 * action to take.
		 */
		private function handleResult( event:ResultEvent ) : void
		{
			trace("Result: "+event.result);
			
			var list:XMLList;
			var nodeName:String = String(XML(event.result).name());
			
			switch( nodeName ) 
			{
				case "articles":
					list = event.result.article;
					createArticleList(list);
					//Alert.show(event.result.article+" event.result.article");
					break;
				case "links":
					list = event.result.link;
					createLinkList(list);
					break;
				case "news":
					list = event.result.blurb;
					createNewsList(list);
					break;
				case "categories":
					list = event.result.category;
					createCategoriesList(list);
					break;
				case "insert":
					if( event.result.success == "true" ) {
						getArticles();
					}
					break;
				case "update":
					if( event.result.success == "true" ) {
						getArticles();
					}
					break;
				case "delete":
					if( event.result.success == "true" ) {
						getArticles();
					} else {
						mx.controls.Alert.show("Could not delete article!", "Delete Error");
					}
					break;
				case "publish":
					if( event.result.success == "true" ) {
						getArticles();
					} else {
						mx.controls.Alert.show("Could not publish article!", "Publish Error");
					}
					break;
				case "newlink":
					if( event.result.success == "true" ) {
						getLinks();
					}
					break;
				case "deletelink":
					if( event.result.success == "true" ) {
						getLinks();
					}
					break;
				case "blogdays":
					list = event.result.day;
					createBlogDays(list, Number(event.result.month), Number(event.result.year));
					break;
			}
		}
		
		/*
		 *
		 */
		 
		/**
		 * send
		 * 
		 * This function overrides the normal send function and prohibits its use. The application
		 * should use the get* functions.
		 */
		override public function send(parameters:Object=null) : AsyncToken
		{
			throw new Error("send() not permitted. Use getArticles(), getLinks(), etc.");
		}
		 
		/**
		 * getArticles
		 * 
		 * This function requests articles which meet certain, optional, critiera. For example, the
		 * request could be for a specific date or category.
		 */
		public function getArticles( published:Boolean=false, excludeNews:Boolean=false, date:Date=null, catcode:String=null ) : void
		{
			url = "phpscripts/getAllArticles.php";
			if( published ) url += "?published=true";
			if( excludeNews ) url += "&excludeNews=true";
			if( date != null ) url += "&month="+(date.month+1)+"&day="+date.date+"&year="+date.fullYear;
			if( catcode != null && catcode != "*" ) url += "&category="+catcode;
			method = "GET";
			super.send();
			trace("Send for articles");
		}
		
		/**
		 * getLinks
		 * 
		 * Requests all of the links for the blog
		 */
		public function getLinks() : void
		{
			url = "phpscripts/getLinks.php";
			method = "GET";
			super.send();
			trace("Send for links");
		}
		
		/**
		 * getCategories
		 * 
		 * Requests the list of categories from the blog.
		 */
		public function getCategories() : void
		{
			url = "phpscripts/getCategories.php";
			method = "GET";
			super.send();
		}
		
		/**
		 * getNews
		 * 
		 * Requests a list of news articles.
		 */
		public function getNews() : void
		{
			url = "phpscripts/getNewsArticles.php";
			method = "GET";
			super.send();
		}
		
		/**
		 * getBlogDays
		 * 
		 * Requests a list of days for the given month (or 'this' month if not given)
		 * for which there are publically readable articles.
		 */
		public function getBlogDays( d:Date=null ) : void
		{
			if( d == null ) d = new Date();
			var month:Number = d.month+1;
			var year:Number  = d.fullYear;
			url = "phpscripts/getBlogDays.php?month="+month+"&year="+year;
			method = "GET";
			super.send();
		}
		
		/**
		 * performSearch
		 * 
		 * Requests the articles whose title or content contains the given
		 * string.
		 */
		public function performSearch( term:String ) : void
		{
			url = "phpscripts/searchBlogs.php?search="+escape(term);
			method = "GET";
			super.send();
		}
		
		/**
		 * insertArticle
		 * 
		 * Inserts a new article into the database, or updates an existing one. The difference is
		 * the value of the articleId. Anything other than 0 (zero) is considered an update.
		 */
		public function insertArticle( articleId:String, title:String, category:String, content:String ) : void
		{
			var params:Object = {};
			
			
			if( articleId == "0" ) {
				url = "phpscripts/insertArticle.php";
				method = "POST";
				
				params.title = title;
				params.category = category;
				params.content = content;
				super.send( params );
			} else {
				url = "phpscripts/updateArticle.php";
				method = "POST";
				
				params.articleId = articleId;
				params.title = title;
				params.category = category;
				params.content = content;
				super.send( params );
			}
		}
		
		/**
		 * deleteArticle
		 * 
		 * Deletes an article from the database given its ID
		 */
		public function deleteArticle( deleteId:String ) : void
		{
			url = "phpscripts/deleteArticle.php";
			method = "GET";
			
			var params:Object = {articleId:deleteId};
			super.send(params);
		}
		
		/**
		 * publishArticle
		 * 
		 * This function flips an article's published flag. Unpublished articles are
		 * not displayed by the Blog Reader.
		 */
		public function publishArticle( pubId:String, publishFlag:Boolean=true ) : void
		{
			url = "phpscripts/publishArticle.php";
			method = "GET";
			
			var params:Object = {articleId:pubId,publish:publishFlag};
			super.send(params);
		}
		
		/**
		 * addLink
		 * 
		 * Adds a new link (eg, "Adobe" and "http://www.adobe.com").
		 */
		public function addLink( linkLabel:String, linkURL:String ) : void
		{
			url = "phpscripts/insertLink.php";
			method = "GET";
			
			var params:Object = {label:linkLabel, url:linkURL};
			super.send(params);
		}
		
		/**
		 * deleteLink
		 * 
		 * Removes a link
		 */
		public function deleteLink( linkLabel:String, linkURL:String ) : void
		{
			url = "phpscripts/deleteLink.php";
			method = "GET";
			
			var params:Object = {label:linkLabel, url:linkURL};
			super.send(params);
		}
		
		/*
		 *
		 */
		
		[Bindable] public var articles:ArrayCollection;
		[Bindable] public var links:ArrayCollection;
		[Bindable] public var news:ArrayCollection;
		[Bindable] public var categories:ArrayCollection;
		[Bindable] public var blogDays:ArrayCollection;
		[Bindable] public var includeNewsCategory:Boolean = false;
		[Bindable] public var includeAllCategories:Boolean = true;
		
		/**
		 * createArticleList
		 * 
		 * Creates the list of articles from the XML data given. Each <article>...</article> XML
		 * element is used to create an Article ActionScript class object.
		 */
		private function createArticleList( list:XMLList ) : void
		{
			articles = new ArrayCollection();
			articles.disableAutoUpdate();
			
			for(var i:int=0; i < list.length(); i++) {
				var node:XML = list[i];
				var d:Date = new Date( Date.parse(node.@date) );
				var a:Article = Article.createArticle(node.@id, node.@title, d, node.@category, node.@categoryCode, node.content, node.@published);
				articles.addItem(a);
			}
			
			articles.enableAutoUpdate();
			
			dispatchEvent(new Event("articlesReady"));
		}
		
		/**
		 * createLinkList
		 * 
		 * Creates the ArrayCollection of links from the given XML. Each <link>...</link> XML
		 * element isused to create a BlogLink ActionScript class object.
		 */
		private function createLinkList( list:XMLList ) : void
		{
			links = new ArrayCollection();
			links.disableAutoUpdate();
			
			for(var i:int=0; i < list.length(); i++) {
				var node:XML = list[i];
				var l:BlogLink = BlogLink.createBlogLink(node.@url, node.@label);
				links.addItem(l);
			}
			
			links.enableAutoUpdate();
		}
		
		/**
		 * createNewsList
		 * 
		 * Creates the ArrayCollection of news articles given the XML. Each <blurb>...</blurb> 
		 * XML element is used to create a NewsHeadline class object.
		 */
		private function createNewsList( list:XMLList ) : void
		{
			news = new ArrayCollection();
			news.disableAutoUpdate();
			
			for(var i:int=0; i < list.length(); i++) {
				var node:XML = list[i];
				var d:Date = new Date( Date.parse(node.@date) );
				var n:NewsHeadline = NewsHeadline.createNewsHeadline(node.@id, d, node.content);
				news.addItem(n);
			}
			
			news.enableAutoUpdate();
		}
		
		/**
		 * createCategoriesList
		 * 
		 * Creates the list of categories from the XML data. Each node in the XML is used
		 * to create a Category class object.
		 */
		private function createCategoriesList( list:XMLList ) : void
		{
			categories = new ArrayCollection();
			categories.disableAutoUpdate();
			
			for(var i:int=0; i < list.length(); i++) {
				var node:XML = list[i];
				if( !includeNewsCategory && node.@code == 0 ) continue;
				if( !includeAllCategories && node.@code == "*" ) continue;
				var c:Category = Category.createCategory(node.@code, node.@label);
				categories.addItem(c);
			}
			
			categories.enableAutoUpdate();
		}
		
		/**
		 * createBlogDays
		 * 
		 * This function creates an ArrayCollection of the days where there is a published article.
		 */
		private function createBlogDays( list:XMLList, month:Number, year:Number ) : void
		{
			var days:ArrayCollection = new ArrayCollection();
			days.disableAutoUpdate();
			
			for(var i:int=0; i < list.length(); i++) {
				var node:XML = list[i];
				var date:Number = list[i].@num;
				var d:Date = new Date(year,month-1,date);
				days.addItem( d );
			}
			
			days.enableAutoUpdate();

			blogDays = days;
		}
		
	}
}