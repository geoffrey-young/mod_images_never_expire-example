use ExtUtils::MakeMaker;

# create 'test' and 'clean' make targets
use Apache::TestMM qw(test clean);

# grab Makefile.PL arguments, such as -apxs or -httpd
Apache::TestMM::filter_args();

# write out t/TEST
use Apache::TestRun ();
Apache::TestRun->generate_script(bugreport => <<EOF);
+-------------------------------------------------------------------+
| something is wrong.  try                                          |
|                                                                   |
|   $ export APACHE_TEST_APXS=/path/to/your/bin/apxs                |
|                                                                   |
| and see if that helps.  also, take a look at the README           |
+-------------------------------------------------------------------+
EOF

my @clean = qw(c-modules/images_never_expire/mod_images_never_expire.so
               c-modules/images_never_expire/Makefile t/TEST);

WriteMakefile(
  NAME      => 'mod_images_never_expire',
  VERSION   => 'example',
  clean     => { FILES => "@clean" },
);
