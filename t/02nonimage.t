use Apache::Test qw(:withtestmore);
use Apache::TestRequest;

use Test::More;

use strict;
use warnings FATAL => qw(all);

# these are all URIs that we don't want to process
my @uri = qw(/foo.html /foogif.html /foo.gif.html /foo/gif/foo.html);

if (need_module('mod_images_never_expire.c')) {
  plan tests => 3 * scalar @uri;
}
else {
  plan skip_all => @Apache::Test::SkipReasons;
}

foreach my $uri (@uri) {

  {
    my $rc = GET_RC $uri;

    is ($rc,
        404,
        "non-existent file returns 404 ($uri)");
  }

  {
    my $rc = GET_RC $uri, 'If-Modified-Since' => 1;

    is ($rc,
        404,
        "If-Modified-Since header returns 404 ($uri)");
  }

  {
    my $rc = GET_RC $uri, 'If-None-Match' => 1;

    is ($rc,
        404,
        "If-Modified-Since header returns 404 ($uri)");
  }
}
