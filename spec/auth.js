var system = require('system');
var args = system.args;

var showError = function (err){
    system.stderr.writeLine("Error: " + err);
    phantom.exit();
};

if(args.length < 5 ){
    showError("Invalid PhantomJS args");
}




var baseUrl = args[1];
var authUrl = args[2];
var userName = args[3];
var password = args[4];


var page = require('webpage').create();
page.open(baseUrl + "/auth/signin", function (status) {
    if(status == "fail") return showError("Error on load /auth/signin");
    page.onLoadFinished = function(status){
        if(status == "fail") return showError("Error on user signing in");
        page.onLoadFinished = null;
        setTimeout(function() {
            page.open(authUrl, function(status){
                if(status == "fail") return showError("Error on loading authorization page");
                setTimeout(function() {
                    page.onLoadFinished = function(status){
                        if(status == "fail") return showError("Error on loading page with pin code");
                        setTimeout(function() {
                            var code = page.evaluate(function() {
                                return $(".pin-code").text();
                            });
                            code = (code || "").trim();
                            if(code.length > 0){
                                console.log(code);
                                phantom.exit();
                            }
                        }, 200);
                    };
                    page.evaluate(function() {
                        $("button[type='submit'].btn-primary").click();
                    });
                }, 200);
            });
        }, 200);
    };
   setTimeout(function() {
        page.evaluate(function(user, pwd) {
            $("input[name='userNameOrEmail']").val(user);
            $("input[name='password']").val(pwd);
            $("button[type='submit']").click();
        }, userName, password);
    }, 200);
});
