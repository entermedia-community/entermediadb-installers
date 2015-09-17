import org.openedit.*
import org.openedit.users.*
import com.openedit.users.*
import org.openedit.data.Searcher
import org.openedit.entermedia.Asset
import org.openedit.entermedia.MediaArchive
import org.openedit.entermedia.scanner.MetaDataReader

import com.openedit.hittracker.*
import com.openedit.modules.update.Downloader
import com.openedit.page.Page
import com.openedit.util.PathUtilities

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