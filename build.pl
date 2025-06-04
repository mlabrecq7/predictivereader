use strict;
use warnings;

my $dir = '/home/mike/.cpan/build';
my $target = 'deps';
qx(rm -rf deps/lib);
qx(mkdir deps/lib);

my @dirs = qx(ls -1 $dir);
chomp(@dirs);
my %packages;

for my $package (@dirs) {
    chomp($package);
    if (-d "$dir/$package") {
	qx(cp -R $dir/$package/lib/* deps/lib); 

    }


}
