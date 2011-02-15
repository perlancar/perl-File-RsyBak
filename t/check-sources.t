#!perl
#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More;
use File::RsyBak;

test_sources(
    name => 'all local = ok',
    sources => ['a', 'b/c'],
);
test_sources(
    name => 'all remote (: syntax), same machine = ok',
    sources => ['user@host:/a', 'user@host:b/c'],
);
test_sources(
    name => 'all remote (: syntax), different machines = error',
    sources => ['user@host:/a', 'user@host2:b/c'],
    dies => 1,
);
test_sources(
    name => 'some remote, some local = error',
    sources => ['a/b', 'user@host:b/c'],
    dies => 1,
);

done_testing();

sub test_sources {
    my %args = @_;
    my $name = $args{name};
    my $sources = $args{sources};

    eval {
        my @sources = map { File::RsyBak::_parse_path($_) } @$sources;
        File::RsyBak::_check_sources(\@sources);
    };
    my $eval_err = $@;
    if ($args{dies}) {
        ok($eval_err, "$name (dies)");
    } else {
        ok(!$eval_err, "$name (doesnt die)") or diag("eval_err=$eval_err");
    }

}

