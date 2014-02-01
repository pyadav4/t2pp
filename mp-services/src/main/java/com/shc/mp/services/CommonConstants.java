package com.shc.mp.services;
/**
 * Constant class.
 * 
 */
public final class CommonConstants {

	/**
	 * Avoiding class instance.
	 */
	private CommonConstants() {
		super();
	}


	public static final String JANRAIN_PROP = "janrainproperties";
	/**
	 * Is Anonymous.
	 */
	public static final String ISANONYMOUS = "isAnonymousU";

	/**
	 * Country depth level = 1.
	 */
	public static final int COUNTRY_DEPTH = 1;


	public static final String CONTENT_ROOT = "/content";

	/* Constants used by components */

	/**
	 * cookieMessage.
	 */
	public static final String COOKIE_OVERLAY_MESSAGE = "cookieMessage";
	/**
	 * "enableOverlay".
	 */
	public static final String COOKIE_OVERLAY_ENABLED = "enableOverlay";

	/**
	 * "jcr:content".
	 */
	public static final String JCR_CONTENT = "jcr:content";

	/**
	 * SLASH " / ".
	 */
	public static final char SLASH = '/';

	/**
	 * SLASH " / ".
	 */
	public static final String SLASH_STRING = "/";

	/**
	 * "redirectTarget".
	 */
	public static final String REDIRECT_URL = "redirectTarget";

	/**
	 * JCR TITLE.
	 */
	public static final String JCR_TITLE = "jcr:title";
	
	public static final String FACEBOOK = "Facebook";
	
	public static final String GOOGLE = "Google";
	
	public static final String userId = "useremail";
	
	public static final String displayName = "displayName";
	
	public static final String formattedName = "formattedName";
	
	public static final String provider = "provider";
	
	public static final String birthday = "birthday";
	
	public static final String familyName = "familyName";
	
	public static final String avatar = "avatar";
	
	public static final String authorizableId = "authorizableId";
	
	public static final String photo = "photo";
	
	public static final String linkedAccount = "linkedAccount";
	
	public static final String identifier = "identifier";
	
	public static final String gender = "gender";
	

	/**
	 * JCR_CONTENT_NODE.
	 */
	public static final String JCR_CONTENT_NODE = JCR_CONTENT;
	
	/**
     * External Email Template
     */
    public static final String EMAIL_CONTACT_US_TEMPLATES_PATH = "/etc/notification/email/html/com.centerofexcellence.contactus.email.external/en.txt";

    /**
     * Internal Email Template
     */
    public static final String EMAIL_CONTACT_US_INTERNAL_TEMPLATES_PATH = "/etc/notification/email/html/com.centerofexcellence.contactus.email.internal/en.txt";

    
	public static final String CQ_DAM = "/content/dam";

	/**
	 * Path for D.COM SNP Content Indexed files /content/dam/snp
	 */

	public static final String COE_SNP = "/content/dam/snp";
	
	
	public static final char tagNamespaceSeparator = ':';

	/**
	 * .html Extension.
	 */
	public static final String HTML_EXTENSION = ".html";

	/**
	 * .xml Extension.
	 */
	public static final String XML_EXTENSION = ".xml";
	

	/**
	 * "jcr:root"
	 */
	public static final String JCR_ROOT = "jcr:root";

	/**
	 * CQ Page Type.
	 */
	public static final String CQ_PAGE = "cq:Page";

	/**
	 * CQ Last Replication Action.
	 */
	public static final String CQ_LAST_REPLICATION_ACTION = "cq:lastReplicationAction";

	/**
	 * CQ Last Replication Action value Activate.
	 */
	public static final String CQ_LAST_REPLICATION_ACTION_ACTIVATE = "Activate";

	public static final String XPATH_AND_PREDICATE = "and";

	public static final String XPATH_NOT_CONSTRAINT = "not";
	

	/**
	 * CQ Template Type.
	 */
	public static final String CQ_TEMPLATE = "cq:template";
	

	/**
	 * Properties Delimiter.
	 */
	public static final String PROP_DELIMITER = "~";

	public static final String HIDE_IN_SEARCH = "hideInSearch";

	public static final String CQ_CREATED = "jcr:createdBy";
	
	/**
	 * Etc Properties for socialmedia icon
	 */
	public static final String SOCIALMEDIA_CONTENT_NODE = "socialmedia";
	public static final String SOCIALMEDIA_CONTENT_PROP_NAME = "configpath";
	
}
