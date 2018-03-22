import org.openedit.*
import org.openedit.users.*
import org.openedit.data.Searcher
import org..entermediadb.asset.Asset
import org.entermediadb.asset.MediaArchive
import org.entermediadb.asset.scanner.MetaDataReader

import org.openedit.hittracker.*
import org.entermediadb.modules.update.Downloader
import org.openedit.page.Page
import org.openedit.util.PathUtilities

public void init() 
{
	Searcher catalogSearcher = searcherManager.getSearcher("system","catalog");

	String email = context.getRequestParameter("organization_email");
	email = email.toLowerCase();
	String name = context.getRequestParameter("name");
	String clientsubdomain = context.getRequestParameter("organization");
	
	Data usercatalog = catalogSearcher.query().match("email",email).searchOne();
	if( usercatalog == null )
	{
			usercatalog = catalogSearcher.createNewData();
			usercatalog.setProperty("email",email);
			usercatalog.setProperty("name",clientsubdomain);
			clientsubdomain = PathUtilities.extractId(clientsubdomain);
			usercatalog.setProperty("clientsubdomain",clientsubdomain);
			usercatalog.setProperty("rootpath","/department" + catalogSearcher.getAllHits().size() );
	}	
	context.putPageValue("tmpcatalog",usercatalog);
}

init();
