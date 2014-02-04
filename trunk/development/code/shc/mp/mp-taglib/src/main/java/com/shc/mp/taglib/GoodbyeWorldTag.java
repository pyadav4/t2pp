package com.shc.mp.taglib;

import com.squeakysand.jsp.tagext.EnhancedSimpleTagSupport;
import com.squeakysand.jsp.tagext.annotations.JspTag;
import com.squeakysand.jsp.tagext.annotations.JspTagAttribute;

import java.io.IOException;

import javax.servlet.jsp.JspException;

/**
 * Friendly tag that says goodbye.
 */
@JspTag
public class GoodbyeWorldTag extends EnhancedSimpleTagSupport {

    private String name;

    @Override
    public void doTag() throws JspException, IOException {
        getJspWriter().write(String.format("Goodbye %s!", name));
    }

    public String getName() {
        return name;
    }

    @JspTagAttribute(required = true, rtexprvalue = true)
    public void setName(String name) {
        this.name = name;
    }

}
