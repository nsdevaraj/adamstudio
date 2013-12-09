use blog;

create table if not exists articles
	( id integer auto_increment primary key,
	  title varchar(60),
	  category varchar(32),
	  edit_dt timestamp default current_timestamp,
	  published boolean default true
	);
	
	
create table if not exists contents
	( articleId integer,
	  content text
	);
	
	
create table if not exists links
	( url varchar(96),
	  label varchar(40)
	);
	

	
create table if not exists news
	( id integer auto_increment primary key,
	  edit_dt timestamp default current_timestamp,
	  content text
	);
	
	

create table if not exists categories
	( code varchar(8),
	  label varchar(40)
	);
	
insert into categories
	set code=0, label='News Article';
insert into categories
	set code=1, label='General Interest';
insert into categories
	set code=2, label='Flex 2';
insert into categories
	set code=3, label='Tech Notes';
		