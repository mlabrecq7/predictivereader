package BaseTest;
use strict;
use warnings;

use base qw(Test::Unit::TestCase);


sub test_compile {
    my ($self) = @_;

    $self->assert_equals(1, 1);


}
1;
