use Humming-Bird::Core;
use Humming-Bird::Middleware;
use Humming-Bird::Advice;
use Template::Mustache;
use Base64;
use Libarchive::Filter :gzip;

# Normally would 'use' local libs here for Controller and Model and
# what not but keeping it simple for now...

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
    my Str $return-url = $request.content.{'hyperlink'};
    my Str $url-scheme = $request.headers.{'X-Forwarded-Proto'} || 'http';
    my Str $url-host   = $request.headers.{'Host'};
    my Str $base-url   = $url-scheme ~ '://' ~ $url-host ~ '/';
    my Str $hyperlink  = $base-url ~ encode-base64(gzip($return-url), :str);
    my Str %stash      =
        title     => 'New hyperlink created',
        hyperlink => $hyperlink;

    $response.html($template.render: 'index', %stash);
});

# Try a wildcard to catch 'all' path
$router.get('/**', -> $request, $response {
    my Str $return-url   = $request.path.substr(1); # Omits the leading slash
    my Str $redirect-url = gunzip(decode-base64($return-url, :bin));

    $response.redirect($redirect-url);
});
