package com.shc.mp.services;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;

import org.osgi.framework.Constants;

/**
 * Example OSGi service using SCR annotations.
 */
@Component(immediate = true, metatype = true)
@Service(HelloWorld.class)
@Properties({
    @Property(name = Constants.SERVICE_VENDOR, value = "CQ Blueprints"),
    @Property(name = Constants.SERVICE_DESCRIPTION, value = "Provides a friendly greeting.")
})
public class HelloWorld {

    public String getMessage() {
        return "Hello World!";
    }

}
