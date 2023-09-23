use v6.d;

use Humming-Bird::Core;

# Normally would 'use' local libs here for Controller and Model and
# what not but keeping it simple for now...

# Must set the root path lest yet miss setting $!root
my $router = Router.new(root => '/');

$router.get(-> $request, $response {
    $response.write('testing 123...')
});
