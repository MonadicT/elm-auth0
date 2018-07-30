export function auth(app) {
    var auth0 = require('auth0-js');
    var jwtDecode = require('jwt-decode');
    //    window.addEventListener('load', function() {
    var webAuth = new auth0.WebAuth({
	domain: process.env.ELM_APP_AUTH0_DOMAIN,
	clientID: process.env.ELM_APP_AUTH0_CLIENT_ID,
	responseType: 'token id_token',
	audience: process.env.ELM_APP_AUTH0_AUDIENCE,
	scope: 'openid email profile',
	redirectUri: "http://localhost:3000/#authorized"
    });


    function handleAuthentication() {
	webAuth.parseHash(function(err, authResult) {
	    if (authResult && authResult.accessToken && authResult.idToken) {
		window.location.hash = '';
		let decodedId = jwtDecode(authResult.idToken);
		let profile = { accessToken: authResult.accessToken,
				email: decodedId.email,
				emailVerified: decodedId.email_verified,
				exp: decodedId.exp,
				name: decodedId.name,
				nickname: decodedId.nickname,
				picture: decodedId.picture,
				sub: decodedId.sub
			      };
		localStorage.setItem('profile', JSON.stringify(profile));
		app.ports.authResponse.send({
		    err: null,
		    ok: profile,
		    stale: false});
	    } else if (err) {
		app.ports.authResponse.send({err: err.error, ok: null, stale: false})
	    }
	});
    }

    app.ports.authStatus.subscribe(function() {
	let profileStr = localStorage.getItem("profile");
	if (profileStr) {
	    let profile = JSON.parse(profileStr)
	    if (profile)
		app.ports.authResponse.send({err: null, ok: profile, stale: false})
	    else
		app.ports.authResponse.send({err: null, ok: profile, stale: true})
	}
	else
	    app.ports.authResponse.send({err: null, ok: null, stale: true})
    });

    app.ports.authRequest.subscribe(function() {
	if (!window.location.hash.startsWith("#access_token")
	    && !window.location.hash.startsWith("#logout"))
	    webAuth.authorize();
    });

    app.ports.authClear.subscribe(function(opts) {
	webAuth.logout({
	    returnTo: 'http://localhost:3000/#logout'
	});
	localStorage.removeItem('profile');
	localStorage.removeItem('token');
    });
    handleAuthentication();
    // });
}
