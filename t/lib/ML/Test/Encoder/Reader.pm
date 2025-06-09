package ML::Test::Encoder::Reader;
use strict;
use warnings;

use base qw(Test::Unit::TestCase);

use ML::Encoder::Reader;

sub test_compile {
    my ($self) = @_;

    my $reader = ML::Encoder::Reader->new();

    
}

sub test_basic_string {
    my ($self) = @_;

    my $reader = ML::Encoder::Reader->new();

    $reader->encodeString('abcdefg', 2);

    $self->assert_equals(1, defined($reader->{data}));

    $self->assert_matches(qr/c/, $reader->getNextChar('ab'));
    $self->assert_matches(qr/a/, $reader->getNextChar('fg'));
    $self->assert_matches(qr/b/, $reader->getNextChar('ga')); 
    
    $reader->encodeString('abcdefg', 3);

    $self->assert_matches(qr/c/, $reader->getNextChar('ab'));
    $self->assert_matches(qr/a/, $reader->getNextChar('fg'));
    $self->assert_matches(qr/b/, $reader->getNextChar('ga')); 

    $self->assert_matches(qr/d/, $reader->getNextChar('abc'));
    $self->assert_matches(qr/a/, $reader->getNextChar('efg'));
    $self->assert_matches(qr/c/, $reader->getNextChar('gab'));     
}

sub test_string_with_uncertainty {
    my ($self) = @_;
    
    my $reader = ML::Encoder::Reader->new();

    $reader->encodeString('abcdefgefg', 2);
    $reader->encodeString('abcdefgefg', 3);

    $self->assert_equals(1, defined($reader->{data}));

    $self->assert_matches(qr/c/, $reader->getNextChar('ab'));
    $self->assert_matches(qr/a|e/, $reader->getNextChar('fg'));
    $self->assert_matches(qr/b/, $reader->getNextChar('ga')); 


}




1;
