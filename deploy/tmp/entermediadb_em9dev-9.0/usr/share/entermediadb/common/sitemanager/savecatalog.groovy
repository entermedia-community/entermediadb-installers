import org.entermediadb.email.PostMail
import org.entermediadb.email.TemplateWebEmail
import org.openedit.*
import org.openedit.data.Searcher
import org.openedit.users.*
import org.openedit.util.DateStorageUtil

import org.openedit.BaseWebPageRequest
import org.openedit.hittracker.*
import org.openedit.users.authenticate.PasswordGenerator
import org.openedit.util.Exec
import org.openedit.util.ExecResult
import org.openedit.util.RequestUtils
import org.entermediadb.asset.MediaArchive

public void init()
{
        String name = context.getRequestParameter("name");
        String email = context.getRequestParameter("email");
        email = email.toLowerCase();
        String catalogname = context.getRequestParameter("catalogname");
        String clientsubdomain = context.getRequestParameter("clientsubdomain");
        String rootpath = context.getRequestParameter("rootpath");

        String plan = context.getRequestParameter("plan");

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

        newcatalog.setProperty("email",email);
        if( plan == null)
        {
                plan = "opensource";
        }
        newcatalog.setProperty("plan",plan);

        newcatalog.setProperty("createdon",DateStorageUtil.getStorageUtil().formatForStorage(new Date()));

        catsearcher.saveData(newcatalog,null);

        //newcatalog.setProperty("owner")
        List command = new ArrayList();
        command.add(clientsubdomain);

        rootpath = rootpath.substring(1);

        command.add(rootpath);
        command.add(catalogname);

        Exec exec = moduleManager.getBean("exec");

        ExecResult done = exec.runExec("setupclient",command);
        log.info("Saving user");
        Searcher usersearcher = searcherManager.getSearcher(newcatalog.getId(),"user");
        User admin = usersearcher.searchById("admin");
        admin.setEmail(email);
        admin.setProperty("screenname",name);
        String password = new PasswordGenerator().generate();
        admin.setPassword(password);
        log.info("Saving password to " + usersearcher.getCatalogId() + " of type " + usersearcher.class );
        usersearcher.saveData(admin,null);
        admin.setPassword(password);
        log.info("done ${catalogid}" );
        if( !done.isRunOk() )
        {
                context.putPageValue("errormsg","Site setup failed");
        }
        else
        {
                context.putPageValue("usercatalog",newcatalog);
                context.putPageValue("newuser",admin);

                MediaArchive mediaarchive = moduleManager.getBean(newcatalog.getId(), "mediaArchive");
                mediaarchive.fireMediaEvent("data/importdatabase", null);

                String hostingdomain = context.findValue("hostingdomain");
//              String link =  "http://${clientsubdomain}.${hostingdomain}/${rootpath}/";
//              context.redirect(link);
                context.putPageValue("subject", "Welcome to EnterMediaDB - ${clientsubdomain}.${hostingdomain}".toString());
                context.putPageValue("from", "noreply@entermediasoftware.com");

                sendEmail(context.getPageMap(),email,"/sitemanager/email/${plan}welcome.html");
                context.putPageValue("from", email);
                context.putPageValue("subject", "New Activation - ${clientsubdomain}.${hostingdomain}".toString());

                sendEmail(context.getPageMap(),"sales@entermediasoftware.com","/sitemanager/email/salesnotify.html");
        }

}


protected void sendEmail(Map pageValues, String email, String templatePage){
        //send e-mail
        //Page template = getPageManager().getPage(templatePage);
        RequestUtils rutil = moduleManager.getBean("requestUtils");
        BaseWebPageRequest newcontext = rutil.createVirtualPageRequest(templatePage,null, null);
        newcontext.putPageValues(pageValues);

        PostMail mail = (PostMail)moduleManager.getBean( "postMail");
        TemplateWebEmail mailer = mail.getTemplateWebEmail();
        mailer.loadSettings(newcontext);
        mailer.setMailTemplatePath(templatePage);
        mailer.setRecipientsFromCommas(email);
        //mailer.setMessage(inOrder.get("sharenote"));
        //mailer.setWebPageContext(context);
        mailer.send();
        log.info("email sent to ${email}");
}

init();

