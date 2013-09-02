var system = require('system');
var args = system.args;
var page = require('webpage').create();

function showError(err){
    system.stderr.writeLine("Error: " + err);
    phantom.exit();
}

if(args.length < 5 ){
    return showError("Invalid PhantomJS args");
}
//var jqueryUrl = "http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js";
var baseUrl = args[1];
var authUrl = args[2];
var userName = args[3];
var password = args[4];
page.open(baseUrl + "/auth/signin", function (status) {
    if(status == "fail") return showError("Error on load /auth/signin");
    page.onLoadFinished = function(status){
        if(status == "fail") return showError("Error on user signing in");
        page.open(authUrl, function(status){
            if(status == "fail") return showError("Error on loading authorisation page");
            page.onLoadFinished = function(status){
                if(status == "fail") return showError("Error on loading page with pin code");
                page.evaluate(function() {
                    system.stdout.writeLine($(".pin-code").text());
                    phantom.exit();
                });
            };
            page.evaluate(function() {
                $("button[type='submit'].btn-primary").click();
            });
        });

    };
    page.evaluate(function() {
        $("input[name='userNameOrEmail']").val(userName);
        $("input[name='password']").val(password);
        $("button[type='submit']").click();
    });
    phantom.exit();
});
