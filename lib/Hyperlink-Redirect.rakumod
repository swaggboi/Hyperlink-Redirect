use Humming-Bird::Core;
use Template6;

# Normally would 'use' local libs here for Controller and Model and
# what not but keeping it simple for now...

# Set things up (config stuff would go here?)
my $templates = Template6.new;
$templates.add-path: 'templates';

# Must set the root path lest yet miss setting $!root
my $router = Router.new(root => '/');

$router.get(-> $request, $response {
    $response.html($templates.process: 'index');
});
