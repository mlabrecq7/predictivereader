package ML::Test::Encoder::Writer;
use strict;
use warnings;

use base qw(Test::Unit::TestCase);

use ML::Encoder::Reader;
use ML::Encoder::Writer;

sub test_basic {
    my ($self) = @_;
    my $reader = ML::Encoder::Reader->new();
    my $writer = ML::Encoder::Writer->new($reader);

    $reader->encodeString('Sally Sold Seashells', 2);
    my $text = $writer->startingFrom('Se', 6);

    $self->assert_equals('Seashell', $text);
    
}
1;
