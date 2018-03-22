import org.openedit.*
import org.openedit.users.*
import org.openedit.data.Searcher
import org.entermediadb.asset.Asset
import org.entermediadb.asset.MediaArchive
import org.entermediadb.asset.scanner.MetaDataReader

import org.openedit.hittracker.*
import org.entermediadb.modules.update.Downloader
import org.openedit.page.Page
import org.openedit.util.PathUtilities

public void init() 
{
	UserSearcher usersearcher = searcherManager.getSearcher("system","user");
	
	String email = context.getRequestParameter("email");
	//email = email.toLowerCase();
	
	User user = usersearcher.getUserByEmail(email);
	if( user == null )
	{
		user = usersearcher.createNewData();
		user.setEmail(email);
		String name = context.getRequestParameter("name");
		user.setProperty("screenname",name);

		String orgname = context.getRequestParameter("organization");
		user.setProperty("business",orgname);

		String phone = context.getRequestParameter("phone");
		user.setProperty("phone",phone);

		usersearcher.saveData(user,null);
	}
	context.putPageValue("client",user);
	
	Searcher catalogSearcher = searcherManager.getSearcher("system","catalog");
	
	Data usercatalog = catalogSearcher.query().match("owner",user.getId()).searchOne();
	context.putPageValue("usercatalog",usercatalog);
	if( usercatalog == null )
	{
			Data tmpcatalog = catalogSearcher.createNewData();
			String clientsubdomain = user.get("business");
			tmpcatalog.setProperty("name",clientsubdomain);
			clientsubdomain = PathUtilities.extractId(clientsubdomain);
			tmpcatalog.setProperty("clientsubdomain",clientsubdomain);
			tmpcatalog.setProperty("rootpath","/department" + catalogSearcher.getAllHits().size() );
			
			context.putPageValue("tmpcatalog",tmpcatalog);
	}	
	//send email with Hash in it?
	
	//context.redirect("./index.html");
	
}

init();
