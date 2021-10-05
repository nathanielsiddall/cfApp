component {

    private boolean function createUser(string username, string password) {
        query = {
            queryString: "INSERT INTO users (username, password) VALUES (:username, :password)",
            isQuerySelect: false,
            params: {
                params: [
                    {name:"username", value: username, sqlType: "CF_SQL_VARCHAR"},
                    {name:"password", value: password, sqlType: "CF_SQL_VARCHAR"}
                    ]
        }
        }
     var result = queryRunner(query);
     return true;

    };

    private void function logAttempt(required string username, required number attempts){
        
        query = {
            queryString: "UPDATE users SET loginAttempt = :loginAttempt WHERE username = :username",
            isQuerySelect: false,
            params: {
                params: [{name:"loginAttempt", value: attempts, sqlType: "CF_SQL_INTEGER"}, {name:"username", value: username, sqlType: "CF_SQL_VARCHAR"}]
        }
        };
        queryRunner(query);
        
    };

    private number function getNumberofLogAttempts(string username) {
        query = {
            queryString: "SELECT loginAttempt FROM users WHERE username = :username",
            isQuerySelect: true,
            params: {
                params: [{name:"username", value: username, sqlType: "CF_SQL_VARCHAR"}]
           }
        };
        
        return val(queryRunner(query).loginAttempt);
    };

    private function queryRunner(struct query) {

        myQry = new Query(datasource="coldfusionapp");
        myQry.setSQL(query.queryString);

        if (StructKeyExists(query.params, "params")) {
            for (i = 1; i <= ArrayLen(query.params.params); i++) {
                var pdata = query.params.params[i];
                myQry.addParam(name=pdata.name, value=pdata.value, CFSQLTYPE=pdata.sqlType);
            }
        }
        try {
            if (query.isQuerySelect) {
                return myQry.execute().getResult();
            } else {
                return myQry.execute();
            }
            
        } catch (any e) {
            writeLog(e);
        }

    };

    private query function getUser(required string username){
        query = {
            queryString: "SELECT userid, username, password, locked, loginAttempt, lastLoginActivity FROM users WHERE username = :username",
            isQuerySelect: true,
            params: {
                params: [{name:"username", value: username, sqlType: "CF_SQL_VARCHAR"}]
           }
        };
        return queryRunner(query);
    };

    private void function lockAccount(required string username){
        query = {
            queryString: "UPDATE users SET locked = true WHERE username = :username",
            isQuerySelect: false,
            params: {
                params: [{name:"username", value: username, sqlType: "CF_SQL_VARCHAR"}]
        }
        };
        queryRunner(query);
    };

    private void function unlockAccount(required string username){
        query = {
            queryString: "UPDATE users SET locked = false WHERE username = :username",
            isQuerySelect: false,
            params: {
                params: [{name:"username", value: username, sqlType: "CF_SQL_VARCHAR"}]
        }
        };
        queryRunner(query);
    };

    private void function updateDTG(required string username){
        query = {
            queryString: "UPDATE users SET lastLoginActivity = :DTG WHERE username = :username",
            isQuerySelect: false,
            params: {
                params: [{name:"DTG", value: now(), sqlType: "CF_SQL_TIMESTAMP"}, {name:"username", value: username, sqlType: "CF_SQL_VARCHAR"}]
        }
        };
        queryRunner(query);
    };


}