component {
    public number function authenticateUser(required string username, required string password) {
writeDump(session);
        var user = getUser(username);
        var authcode = 2;
        // writeDump(user);

        if (user.doesExist) {
            if (user.payload.locked EQ true AND dateDiff("h", user.payload.lastLoginActivity, now()) LTE 24) {
                authcode = 1;
            } else {
                setDTG(username);
                unlockAccount(username);
                if (user.payload.password EQ password) {
                   authcode = 0;
                   clearAttempts(username); 
                   session.login = true;
                   session.userid = user.payload.userid;
                   cflocation(url="views/home.cfm" addtoken="false");
               } else { 
                   if (user.payload.loginAttempt GTE 5) {
                       authcode = 1;
                       lockAccount(username);
                   } else {
                       authcode = 2;
                       incrementAttempt(username);
                   }
               }
            }
        }
        return authcode;     
    };

    private void function lockAccount(required string username){
        var login = new models.login().lockAccount(username);
    };

    private void function unlockAccount(required string username){
        var login = new models.login().unlockAccount(username);
    };

    private void function clearAttempts(required string username){
        var login = new models.login().logAttempt(username, 0);
    };

    private void function incrementAttempt(required string username){
        var login = new models.login();

        var loginAttempts = login.getNumberofLogAttempts(username);
        loginAttempts++;
        var logAttempt = login.logAttempt(username, loginAttempts);
    };

    private struct function getUser(required string username) {
        dataset = new models.login().getUser(username);
        var data = {};
        data.doesExist = false;
        if (dataset.RecordCount GT 0) {
            data.doesExist = true;
            data.payload = QueryGetRow(dataset, 1);
        }
        return data;
    };

    private void function setDTG(required string username){
        var login = new models.login().updateDTG(username);
    };
}