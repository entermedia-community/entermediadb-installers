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