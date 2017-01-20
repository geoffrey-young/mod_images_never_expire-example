use Apache::Test qw(:withtestmore);
use Apache::TestRequest;

use Test::More;

use strict;
use warnings FATAL => qw(all);

# try out a bunch of image types that should be processed
my @uri = map { "/foo.$_" } qw(gif png jpg jpeg);

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
        "non-existent gif returns 404 ($uri)");
  }

  {
    my $rc = GET_RC $uri, 'If-Modified-Since' => 1;

    is ($rc,
        304,
        "If-Modified-Since header forces 304 ($uri)");
  }

  {
    my $rc = GET_RC $uri, 'If-None-Match' => 1;

    is ($rc,
        304,
        "If-Modified-Since header forces 304 ($uri)");
  }
}
