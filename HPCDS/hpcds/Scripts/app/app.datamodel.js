﻿function AppDataModel(appBaseUrl) {
    var self = this;
    // Routes
    self.userInfoUrl = appBaseUrl + "api/Me";
    self.siteUrl = appBaseUrl ;

    // Route operations

    // Other private operations

    // Operations

    // Data
    self.returnUrl = self.siteUrl;

    // Data access operations
    self.setAccessToken = function (accessToken) {
        sessionStorage.setItem("accessToken", accessToken);
    };

    self.getAccessToken = function () {
        return sessionStorage.getItem("accessToken");
    };
    
}
