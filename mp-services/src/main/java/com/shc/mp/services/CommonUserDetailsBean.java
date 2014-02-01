package com.shc.mp.services;


public class CommonUserDetailsBean {
	private String stat;
	private String url;
	private String preferredUsername;
	private String email;
	private String givenName;
	private String identifier;
	private String familyName;
	private String displayName;
	private String verifiedEmail;
	private String formattedName;
	private String providerName;
	private String name;
	private String photo;
	private String birthday;
	private String utcOffset;
	private String address;
	private String type;
	private String gender;
	private String limited_data;
	private String googleUserId;
	private String linkedAccount ="";
	
	public String getGoogleUserId() {
		if(googleUserId == null || googleUserId.trim().length() == 0)
			googleUserId = "";
		return googleUserId;
	}
	public void setGoogleUserId(String googleUserId) {
		this.googleUserId = googleUserId;
	}
	public String getPhoto() {
		if(photo == null || photo.trim().length() == 0)
			photo = "";
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	public String getBirthday() {
		if(birthday == null || birthday.trim().length() ==0)
			birthday = "";
		return birthday;
	}
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	public String getUtcOffset() {
		if(utcOffset == null || utcOffset.trim().length() == 0)
			utcOffset = "";
		return utcOffset;
	}
	public void setUtcOffset(String utcOffset) {
		this.utcOffset = utcOffset;
	}
	public String getAddress() {
		if(address == null || address.trim().length() == 0)
			address = "";
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getType() {
		if(type == null || type.trim().length() == 0)
			type = "";
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getGender() {
		if(gender == null || gender.trim().length() == 0)
			gender = "";
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getLimited_data() {
		if(limited_data == null || limited_data.trim().length() == 0)
			limited_data = "";
		return limited_data;
	}
	public void setLimited_data(String limitedData) {
		limited_data = limitedData;
	}
	public String getName() {
		if(name == null || name.trim().length() == 0)
			name = "";
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStat() {
		if(stat == null || stat.trim().length() == 0)
			stat = "";
		return stat;
	}
	public void setStat(String stat) {
		this.stat = stat;
	}
	public String getUrl() {
		if(url == null || url.trim().length() == 0)
			url = "";
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getPreferredUsername() {
		if(preferredUsername == null || preferredUsername.trim().length() == 0)
			preferredUsername = "";
		return preferredUsername;
	}
	public void setPreferredUsername(String preferredUsername) {
		this.preferredUsername = preferredUsername;
	}
	public String getEmail() {
		if(email == null || email.trim().length() == 0)
			email = "";
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getGivenName() {
		if(givenName == null || givenName.trim().length() == 0)
			givenName = "";
		return givenName;
	}
	public void setGivenName(String givenName) {
		this.givenName = givenName;
	}
	public String getIdentifier() {
		if(identifier == null || identifier.trim().length() == 0)
			identifier = "";
		return identifier;
	}
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	public String getFamilyName() {
		if(familyName == null || familyName.trim().length() == 0)
			familyName = "";
		return familyName;
	}
	public void setFamilyName(String familyName) {
		this.familyName = familyName;
	}
	public String getDisplayName() {
		if(displayName == null || displayName.trim().length() == 0)
			displayName = "";
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getVerifiedEmail() {
		if(verifiedEmail == null || verifiedEmail.trim().length() == 0)
			verifiedEmail = "";
		return verifiedEmail;
	}
	public void setVerifiedEmail(String verifiedEmail) {
		this.verifiedEmail = verifiedEmail;
	}
	public String getFormattedName() {
		if(formattedName == null || formattedName.trim().length() == 0)
			formattedName = "";
		return formattedName;
	}
	public void setFormattedName(String formattedName) {
		this.formattedName = formattedName;
	}
	public String getProviderName() {
		if(providerName == null || providerName.trim().length() == 0)
			providerName = "";
		return providerName;
	}
	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}
	
	public String getLinkedAccount() {
		if(linkedAccount == null || linkedAccount.trim().length() == 0)
			linkedAccount = "";
		return linkedAccount;
	}
	public void setLinkedAccount(String linkedAccount) {
		this.linkedAccount = linkedAccount;
	}
	public String addLinkedAccount(String linkedAccount) {
		if(linkedAccount!=null && !"".equalsIgnoreCase(linkedAccount) && !this.linkedAccount.contains(linkedAccount))
		{
			this.linkedAccount = this.linkedAccount + "#" + linkedAccount;
		}
		return this.linkedAccount;
	}
	
	public String toString() {
		return "stat~"+stat+"~url~"+url+"~email~"+email+"~displayName~"+displayName+"~providerName~"+providerName+"~verifiedEmail~"+verifiedEmail;
	}
	
}

