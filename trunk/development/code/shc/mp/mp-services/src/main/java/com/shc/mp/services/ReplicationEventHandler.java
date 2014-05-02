package com.shc.mp.services;
import java.io.IOException;

import javax.jcr.Node;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.LoginException;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.event.jobs.JobProcessor;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.osgi.service.cm.Configuration;
import org.osgi.service.cm.ConfigurationAdmin;
import org.osgi.service.event.Event;
import org.osgi.service.event.EventHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.replication.ReplicationAction;
import com.day.cq.replication.ReplicationActionType;
import com.day.cq.replication.Replicator;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;

@SuppressWarnings("deprecation")
@Service(value = EventHandler.class)
@Component(immediate = true)
@Property(name = "event.topics", value = ReplicationAction.EVENT_TOPIC)
public class ReplicationEventHandler implements EventHandler, JobProcessor {
	private static final Logger LOGGER = LoggerFactory.getLogger(ReplicationEventHandler.class);
	@Reference
	private JcrResourceResolverFactory jcrResourceResolverFactory;
	@Reference
	private Replicator replicator;
	@Reference
	private SitemapUtil sMapUtil;
	@Reference
    private ConfigurationAdmin configAdmin;
	
	private String siteRoot;
	
	@Override
	public void handleEvent(Event event) {
		LOGGER.info("********handling event");
		process (event);
	}
	@Override
	public boolean process(Event event) {
		LOGGER.info("********processing job");
		intializeParams();
		ReplicationAction action = ReplicationAction.fromEvent(event);
		ResourceResolver resourceResolver = null;
		if (action.getType().equals(ReplicationActionType.ACTIVATE) || action.getType().equals(ReplicationActionType.DEACTIVATE)) {
			try {
				resourceResolver = jcrResourceResolverFactory.getAdministrativeResourceResolver(null);
				Node sessionNode = resourceResolver.getResource("/content").adaptTo(Node.class);
				final PageManager pm = resourceResolver.adaptTo(PageManager.class);
				final Page page = pm.getContainingPage(action.getPath());
				if(page != null) {
					sMapUtil.buildSiteMap(this.siteRoot);
				    replicator.replicate(sessionNode.getSession(),ReplicationActionType.ACTIVATE,"/content/training-site-5/sitemap.xml");
					
				   
					LOGGER.info("********activation of page {}", page.getTitle());
				}
			}
			catch (LoginException e) {
				e.printStackTrace();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			finally {
				if(resourceResolver != null && resourceResolver.isLive()) {
					resourceResolver.close();
				}
			}
		}
		return true;
	}
	
	public void intializeParams(){
        Configuration config = null;
        try {
			config = configAdmin.getConfiguration("com.shc.mp.services.ReplicationEventHandler");
             this.siteRoot = (String)config.getProperties().get("sitemap.siteroot");
     		 //System.out.println("Param Values :{}"+ this.siteRoot);

		} catch (IOException e) {
			LOGGER.error("Error occured in intializeParams of ReplicationEventHandler", e);
		}catch (Exception e) {
			LOGGER.error("Error occured in intializeParams of ReplicationEventHandler", e);
		}
		
	}
}