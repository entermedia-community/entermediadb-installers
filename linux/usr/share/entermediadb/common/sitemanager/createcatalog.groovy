import org.openedit.*
import org.openedit.data.Searcher
import org.openedit.users.*

import com.openedit.hittracker.*
import com.openedit.users.*
import com.openedit.util.Exec
import com.openedit.util.ExecResult

public void init() 
{
	String catalogname = context.getRequestParameter("catalogname");
	String clientsubdomain = context.getRequestParameter("clientsubdomain");
	String rootpath = context.getRequestParameter("rootpath");
	
	String catalogid = rootpath.substring(1) + "/catalog";
	Searcher catsearcher = searcherManager.getSearcher("system","catalog");
	
	Data newcatalog = searcherManager.getData("system","catalog",catalogid);
	if( newcatalog == null)
	{
		newcatalog = catsearcher.createNewData();
		newcatalog.setId(catalogid);
	}
	newcatalog.setName(catalogname);
	newcatalog.setProperty("clientsubdomain",clientsubdomain);
	newcatalog.setProperty("rootpath",rootpath);
	catsearcher.saveData(newcatalog,null);

	//newcatalog.setProperty("owner")
	List command = new ArrayList();
	command.add(clientsubdomain);
		
	rootpath = rootpath.substring(1);
	
	command.add(rootpath);
	
	command.add(catalogname);
	
	Exec exec = moduleManager.getBean("exec");
	
	ExecResult done = exec.runExec("setupclient",command);
	log.info("done ${catalogid}" );
	if( !done.isRunOk() )
	{
		context.putPageValue("errormsg","Site setup failed");
	}
	else
	{
		context.putPageValue("usercatalog",newcatalog);
	}
	//context.redirect("./index.html");
	
}

init();
