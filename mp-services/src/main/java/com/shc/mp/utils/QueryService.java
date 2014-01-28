package com.shc.mp.utils;

import java.util.List;

import javax.jcr.RepositoryException;
import javax.jcr.query.InvalidQueryException;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.api.resource.Resource;

public interface QueryService {
	
	/**
      * This method is used to executing the query and getting the results
      * 
      */
    public List<String> getSQL2QueryResults(Resource resource, String geoPath, int offsetLimit, SlingScriptHelper sling) throws InvalidQueryException, RepositoryException;
}
