package com.shc.mp.services;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.jcr.Binary;
import javax.jcr.Node;
import javax.jcr.PathNotFoundException;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.ValueFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang.StringUtils;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.LoginException;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceResolverFactory;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.day.cq.replication.Replicator;
import com.day.cq.wcm.api.Page;

@Service(value = SitemapUtil.class)
@Component(immediate = true, metatype = true)
public class SitemapUtil {

	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Reference
	ResourceResolverFactory resolverFactory;
	
	@Reference
	Replicator replicator;
	
	@Reference
	private SlingRepository repository;
	
	private Session session = null;

	public void buildSiteMap(String baseURL) {
		log.info("Building up sitemap.xml");
		ResourceResolver resourceResolver = null;
		
		try {
			resourceResolver = resolverFactory
					.getAdministrativeResourceResolver(null);
			//String baseURL = "/content/training-site-5";
			String host = "localhost";
			String fullUrl = "";
			//Session jcrSession = session.getSession();
			
			session = createAdminSession();
			Map<String, Object> authInfo = new HashMap<String, Object>();
			authInfo.put(JcrResourceConstants.AUTHENTICATION_INFO_SESSION,
					session);
	
			if (StringUtils.isNotBlank(baseURL) && session.itemExists(baseURL)) {
				Node baseNode = session.getNode(baseURL);
			
				if (baseNode != null) { // If base node is not null
					// Get the rootPage
					Page rootPage = resourceResolver.getResource(baseNode.getPath()).adaptTo(
							com.day.cq.wcm.api.Page.class);
					// Get the host
					fullUrl = host+baseURL;// need to see how to get host info
					log.debug("fullUrl : " + fullUrl);
					// Generates the sitemap
					ByteArrayOutputStream xml = getSitemap(fullUrl, rootPage, baseNode);
					// Write the sitemap
					writeSitemap(xml, baseNode);
					
					log.info(" sitemap processing step completed");
				}
			}
		} catch (LoginException e) {
			log.error("Repository error in sitemap workflow", e);
		}catch (TransformerException e) {
			log.error("Transformer error in sitemap workflow", e);
		} catch (ParserConfigurationException e) {
			log.error("Parse error in sitemap workflow", e);
		} catch (PathNotFoundException e) {
			log.error("Path not found in sitemap workflow", e);
		} catch (RepositoryException e) {
			log.error("Repository error in sitemap workflow", e);
		}  catch (Exception e) {
			log.error("Repository error in sitemap workflow", e);
		} finally {
			if (resourceResolver != null) {
				resourceResolver.close();
				resourceResolver = null;
			}
		}

	}

	/**
	 * Method to get the sitemap.xml of the site.
	 * 
	 * @param host
	 *            the site host
	 * @param rootPage
	 *            the root page of the site
	 * @param baseURL
	 *            the baseURL of the site
	 * @throws ParserConfigurationException .
	 * @throws WorkflowException .
	 * @throws TransformerException .
	 * @throws RepositoryException .
	 * @return ByteArrayOutputStream the sitemap.xml byte array representation
	 */
	private ByteArrayOutputStream getSitemap(String host, Page rootPage, Node baseNode)
			throws ParserConfigurationException,  TransformerException, RepositoryException {
		// Create a new xml document
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		docFactory.setNamespaceAware(true);
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();
		// doc.createe
		// Create the xml root element
		Element rootElement = doc.createElementNS("http://www.sitemaps.org/schemas/sitemap/0.9", "urlset");
		rootElement.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:xsi",
				"http://www.w3.org/2001/XMLSchema-instance");
		rootElement.setAttributeNS("http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation",
				"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd");
		doc.appendChild(rootElement);
		// Build the sitemap and completing the xml
		buildSitemap(host, rootPage, baseNode, doc, rootElement);
		// Transform the xml into an ByteArrayOutputStream
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		Transformer transformer = transformerFactory.newTransformer();
		DOMSource source = new DOMSource(doc);
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		StreamResult result = new StreamResult(outputStream);
		transformer.transform(source, result);
		log.debug("Sitemap XML : {}", outputStream.toString());
		return outputStream;
	}

	/**
	 * Recursive method that generate the sitemap.
	 * 
	 * @param host
	 *            the site host
	 * @param rootPage
	 *            the root page of the site
	 * @param baseURL
	 *            the baseURL of the site
	 * @param doc
	 *            the xml document
	 * @param rootElement
	 *            the xml root element
	 * @throws WorkflowException .
	 * @throws RepositoryException .
	 */
	private void buildSitemap(String host, Page rootPage, Node baseNode, Document doc, Element rootElement)
			throws  RepositoryException {
		String baseURL = baseNode.getPath();
		int baseNodeDepth = baseNode.getDepth();
		log.debug("baseURL : " + baseURL + "### baseNodeDepth : " + baseNodeDepth);
		int rootPageDepth = rootPage.getDepth();
		log.debug("rootPageDepth : " + rootPageDepth);
		
		int currentPageDepth = 0;
		log.debug("rootPage is : " + rootPage.getPath());
		Iterator<Page> childPages = rootPage.listChildren();
		log.debug("rootPage = " + rootPage.getPath() + "---rootPage children : " + childPages.hasNext());
		while (childPages.hasNext()) {
			Page page = childPages.next();
			currentPageDepth = page.getDepth();
			log.debug("currentPage : " + page.getPath() + " ### currentPageDepth : " + currentPageDepth);
			if (page.hasContent()) {
				if (!page.isHideInNav() && replicator.getReplicationStatus(page.adaptTo(Node.class).getSession(), page.getPath()).isActivated()) { // Check if the page is hidden in nav
					// <url> element
				System.out.println("Page path "+ page.getPath());
					Element url = doc.createElement("url");
					rootElement.appendChild(url);
					//title element
					Element title = doc.createElement("title");
					title.appendChild(doc.createTextNode(page.getTitle()));
					url.appendChild(title);
					
					// <loc> element
					Element loc = doc.createElement("loc");
					loc.appendChild(doc.createTextNode(host + page.getPath().replaceFirst(baseURL, "") + ".html"));
					url.appendChild(loc);
					// <lastmod> element
					if (page.getLastModified() != null) { // Check for null
															// dates
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						String lastModified = sdf.format(page.getLastModified().getTime());
						Element lastmod = doc.createElement("lastmod");
						lastmod.appendChild(doc.createTextNode(lastModified));
						url.appendChild(lastmod);
					}

				}
			}
			buildSitemap(host, page, baseNode, doc, rootElement);
		}
	}

	/**
	 * Method to write the sitemap.xml of the site.
	 * 
	 * @param xml
	 *            .
	 * @param baseNode
	 *            the base node of the site
	 * @throws WorkflowException .
	 * @throws RepositoryException .
	 */
	private void writeSitemap(ByteArrayOutputStream xml, Node baseNode) throws  RepositoryException {
		// Check if the xml node exist
		Node xmlNode = null;
		Node jcrContent;
		if (baseNode.hasNode("sitemap.xml")) {
			xmlNode = baseNode.getNode("sitemap.xml");
			jcrContent = xmlNode.getNode("jcr:content");
		} else {
			xmlNode = baseNode.addNode("sitemap.xml", "nt:file");
			jcrContent = xmlNode.addNode("jcr:content", "nt:resource");
			jcrContent.setProperty("jcr:mimeType", "text/xml");
			jcrContent.setProperty("jcr:encoding", "UTF-8");
		}
		// Convert the xml into a binary value to store in the CRX
		InputStream is = new ByteArrayInputStream(xml.toByteArray());
		ValueFactory vf = jcrContent.getSession().getValueFactory();
		Binary data = vf.createBinary(is);
		jcrContent.setProperty("jcr:data", data);
		xmlNode.getSession().save(); // Save all changes
		// Close all the streams
		try {
			is.close();
			xml.flush();
			xml.close();
		} catch (IOException e) {
			log.error("IOException error in sitemap workflow", e);
		}
	}
	
	private Session createAdminSession() {
		try {
			return this.repository.loginAdministrative(null);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		} finally {
			if (session != null) {
				session.logout();
			}
		}
		return null;
	}

}