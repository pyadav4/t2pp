package com.shc.mp.beans;

public class BCBean {
      
      private String image;
      private String pageTitle;
      private String pageSubTitle;
      private String pageDescription;
      private String pagePath;
      
      public String getPagePath() {
		return pagePath;
	  }
      public void setPagePath(String pagePath) {
		this.pagePath = pagePath;
      }
      public String getImage() {
            return image;
      }
      public void setImage(String image) {
            this.image = image;
      }
      public String getPageTitle() {
            return pageTitle;
      }
      public void setPageTitle(String pageTitle) {
            this.pageTitle = pageTitle;
      }
      public String getPageSubTitle() {
            return pageSubTitle;
      }
      public void setPageSubTitle(String pageSubTitle) {
            this.pageSubTitle = pageSubTitle;
      }
      public String getPageDescription() {
            return pageDescription;
      }
      public void setPageDescription(String pageDescription) {
            this.pageDescription = pageDescription;
      }
      
      @Override
    public String toString() {
    	// TODO Auto-generated method stub
    	return "image-"+image+";pageTitle-"+pageTitle;
    }
}

