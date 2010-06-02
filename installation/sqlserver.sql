CREATE TABLE dbo.galleon_privatemessages ( 
	[id]        	nvarchar(35) NOT NULL,
	fromuseridfk  	nvarchar(35) NOT NULL,
	touseridfk  	nvarchar(35) NOT NULL,
	sent 	datetime NULL, 
	body      	ntext NOT NULL,
	subject     	nvarchar(255) NOT NULL,
	unread          	tinyint NOT NULL
	)
GO

CREATE TABLE dbo.galleon_conferences ( 
	[id]              	nvarchar(35) NOT NULL,
	[name]            	nvarchar(255) NOT NULL,
	[description]     	nvarchar(255) NOT NULL,
	active          	bit NOT NULL,
	messages        	int NULL,
	lastpost        	varchar(35) NULL,
	lastpostuseridfk	varchar(35) NULL,
	lastpostcreated 	datetime NULL 
	)
GO

CREATE TABLE [dbo].[galleon_forums] ( 
    [id]              	nvarchar(35) NOT NULL,
    [name]            	nvarchar(255) NOT NULL,
    [description]     	nvarchar(255) NOT NULL,
    [active]          	bit NOT NULL,
    [attachments]     	bit NOT NULL,
    [conferenceidfk]  	nvarchar(35) NOT NULL,
    [messages]        	int NULL,
    [lastpost]        	varchar(35) NULL,
    [lastpostuseridfk]	varchar(35) NULL,
    [lastpostcreated] 	datetime NULL,
    CONSTRAINT [PK_forums] PRIMARY KEY([id])
)

CREATE TABLE dbo.galleon_groups ( 
	[id]   	nvarchar(35) NOT NULL,
	[group]	nvarchar(50) NOT NULL 
	)
GO
CREATE TABLE dbo.galleon_messages ( 
	[id]        	nvarchar(35) NOT NULL,
	title     	nvarchar(255) NOT NULL,
	body      	ntext NOT NULL,
	posted    	datetime NOT NULL,
	useridfk  	nvarchar(35) NOT NULL,
	threadidfk	nvarchar(35) NOT NULL,
	attachment	nvarchar(255) NOT NULL,
	[filename]  	nvarchar(255) NOT NULL 
	)
GO
CREATE TABLE dbo.galleon_permissions ( 
	[id]          	varchar(35) NOT NULL,
	rightidfk   	varchar(35) NOT NULL,
	resourceidfk	varchar(35) NOT NULL,
	groupidfk   	varchar(35) NOT NULL 
	)
GO
CREATE TABLE galleon_threads ( 
	[Id]              	varchar(35) NOT NULL,
	[name]            	varchar(255) NOT NULL,
	active          	tinyint NOT NULL,
	useridfk        	varchar(35) NOT NULL,
	forumidfk       	varchar(35) NOT NULL,
	datecreated     	datetime NOT NULL,
	sticky          	tinyint NOT NULL,
	messages        	int NULL,
	lastpostuseridfk	varchar(35) NULL,
	lastpostcreated 	datetime NULL 
	)
GO
CREATE TABLE dbo.galleon_ranks ( 
	id      	nvarchar(35) NOT NULL,
	name    	nvarchar(50) NOT NULL,
	minposts	int NOT NULL 
	)
GO
CREATE TABLE dbo.galleon_rights ( 
	[id]   	varchar(35) NOT NULL,
	[right]	varchar(255) NOT NULL 
	)
GO
CREATE TABLE dbo.galleon_search_log ( 
	searchterms 	nvarchar(255) NOT NULL,
	datesearched	datetime NOT NULL 
	)
GO
CREATE TABLE dbo.galleon_subscriptions ( 
	id            	nvarchar(35) NOT NULL,
	useridfk      	nvarchar(35) NOT NULL,
	threadidfk    	nvarchar(35) NULL,
	forumidfk     	nvarchar(35) NULL,
	conferenceidfk	nvarchar(35) NULL 
	)
GO


CREATE TABLE dbo.galleon_users_groups ( 
	useridfk 	nvarchar(35) NOT NULL,
	groupidfk	nvarchar(35) NOT NULL 
	)
GO
CREATE TABLE dbo.galleon_users ( 
	id          	nvarchar(35) NOT NULL,
	username    	nvarchar(50) NOT NULL,
	password    	nvarchar(50) NOT NULL,
	emailaddress	nvarchar(255) NOT NULL,
	signature   	nvarchar(1000) NOT NULL,
	datecreated 	datetime NOT NULL,
	confirmed   	bit NOT NULL ,
	avatar      	nvarchar(255) NULL 
	)
GO

ALTER TABLE dbo.galleon_privatemessages
	ADD CONSTRAINT PK_privatemessages
	PRIMARY KEY (id)
GO

ALTER TABLE dbo.galleon_conferences
	ADD CONSTRAINT PK_conferences
	PRIMARY KEY (id)
GO

ALTER TABLE dbo.galleon_groups
	ADD CONSTRAINT PK_groups
	PRIMARY KEY (id)
GO
ALTER TABLE dbo.galleon_messages
	ADD CONSTRAINT PK_messages
	PRIMARY KEY (id)
GO
ALTER TABLE dbo.galleon_permissions
	ADD CONSTRAINT galleon_permissions_pk
	PRIMARY KEY (id)
GO
ALTER TABLE dbo.galleon_ranks
	ADD CONSTRAINT PK_galleon_ranks
	PRIMARY KEY (id)
GO
ALTER TABLE dbo.galleon_rights
	ADD CONSTRAINT primarykeygalleonrights
	PRIMARY KEY (id)
GO
ALTER TABLE dbo.galleon_subscriptions
	ADD CONSTRAINT PK_subscriptions
	PRIMARY KEY (id)
GO

ALTER TABLE dbo.galleon_users
	ADD CONSTRAINT PK_users
	PRIMARY KEY (id)
GO


insert into [dbo].[galleon_users](id,username,password,emailaddress,datecreated,confirmed,signature)
values('AD0CD90E-07C8-CFFE-F80C5EB6688AF47A','admin','21232F297A57A5A743894A0E4A801FC3','admin@127.0.0.1',getDate(),1,'')
GO

insert into [dbo].[galleon_groups](id,[group])
values('AD0EA988-0C8E-E2B3-DF0CF594C5DAAD63','forumsadmin')
GO

insert into [dbo].[galleon_groups](id,[group])
values('AD0F29B5-BEED-B8BD-CAA9379711EBF168','forumsmember')
GO

insert into [dbo].[galleon_groups](id,[group])
values('AD0F717C-AFE5-FD0E-77EB8FF5BDD858A2','forumsmoderator')
GO

insert into [dbo].[galleon_users_groups](useridfk,groupidfk)
values('AD0CD90E-07C8-CFFE-F80C5EB6688AF47A','AD0EA988-0C8E-E2B3-DF0CF594C5DAAD63')
go

INSERT INTO [dbo].[galleon_rights](id,[right])
  VALUES('7EA5070B-9774-E11E-96E727122408C03C', 'CanView')
GO
INSERT INTO [dbo].[galleon_rights](id, [right])
  VALUES('7EA5070C-E788-7378-8930FA15EF58BBD2', 'CanPost')
GO
INSERT INTO [dbo].[galleon_rights](id, [right])
  VALUES('7EA5070D-CB58-72BA-2E4A3DFC0AE35F35', 'CanEdit')
GO