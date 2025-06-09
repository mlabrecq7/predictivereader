package ML::Test::Encoder::Writer;
use strict;
use warnings;

use base qw(Test::Unit::TestCase);

use ML::Encoder::Reader;
use ML::Encoder::Writer;

sub test_compile {
    my ($self) = @_;
    my $reader = ML::Encoder::Reader->new();
    my $writer = ML::Encoder::Writer->new($reader);

    



}
1;
