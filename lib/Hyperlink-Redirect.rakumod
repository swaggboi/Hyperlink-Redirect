use Humming-Bird::Core;
use Humming-Bird::Middleware;
use Humming-Bird::Advice;
use Template::Mustache;

# Normally would 'use' local libs here for Controller and Model and
# what not but keeping it simple for now...
# UPDATE: We now have local lib (sry libs)
use Hyperlink-Redirect::Helpers;

# Set things up (config stuff would go here?)
my $template = Template::Mustache.new: :from<../templates>;

# Logging
middleware &middleware-logger;
advice     &advice-logger;

# Must set the root path lest yet miss setting $!root
my $router = Router.new(root => '/');

$router.get(-> $request, $response {
    my Str %stash = title => 'Create new hyperlink';

    $response.html($template.render: 'index', %stash);
});

$router.post(-> $request, $response {
    my Str  $return-url   = fix-protocol($request.content<hyperlink>);
    my Bool $meta-refresh = $request.content<meta-refresh>.defined;
    my Str  $url-scheme   = $request.headers<x-forwarded-proto> || 'http';
    my Str  $url-host     = $request.headers<host>;
    my (Str $base-url, Str $hyperlink, Str %stash);

    $base-url = $url-scheme ~ '://' ~ $url-host ~
        ($meta-refresh ?? '/--meta-refresh/' !! '/');

    $hyperlink = $base-url ~ hyperlink $return-url;

    %stash = title => 'New hyperlink created', :$hyperlink;

    $response.html($template.render: 'index', %stash);
});

# Don't try to process favicon as a hyperlink
$router.get('/favicon.ico', -> $request, $response {
    $response.status(204)
});

# Process the hyperlink
$router.get('/--meta-refresh/**', -> $request, $response {
    my Str $return-url   = $request.path.subst: /^ '/--meta-refresh/'/, Empty;
    my Str $redirect-url = redirect $return-url;
    my Str %stash        = title => 'Hyperlinking...', :$redirect-url;

    $response.html($template.render: 'index', %stash);
});

$router.get('/**', -> $request, $response {
    my Str $return-url   = $request.path.substr(1); # Omits the leading slash
    my Str $redirect-url = redirect $return-url;

    $response.redirect($redirect-url);
});
