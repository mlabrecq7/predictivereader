package ML::Test::Encoder::Reader;
use strict;
use warnings;

use base qw(Test::Unit::TestCase);
use File::Temp;

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

sub test_special_string {
    my ($self) = @_;

    my $reader = ML::Encoder::Reader->new();

    $reader->encodeString('abcdefg,', 2);

    $self->assert_equals(1, defined($reader->{data}));

    $self->assert_matches(qr/,/, $reader->getNextChar('fg'));

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


sub test_loader {
    my ($self) = @_;
    
    my $reader = ML::Encoder::Reader->new();

    $self->assert_equals(1, !defined($reader->{'data'}->{abc}));
    my $dir = File::Temp->newdir();
    my $file = "$dir/this";
    open(my $FILE, '>', $file);
    print $FILE "abc,c,400,d,3,T,70,[COMMA],500\n";
    close($FILE);
    $reader->_loadData($file);
    
    $self->assert_equals(3, $reader->{data}->{'abc'}->{d});
    $self->assert_equals(3, $reader->{data}->{'abc'}->{d});

    $self->assert_equals(',', $reader->getNextChar('abc'));
}

sub test_saveData {
    my ($self) = @_;
    my $reader = ML::Encoder::Reader->new();

    $reader->encodeString('abc,', 2);

    my $dir = File::Temp->newdir();
    my $file = "$dir/this";
    $self->assert_equals(1, !-e $file);
    
    $reader->_saveData($file);

    $self->assert_equals(1, -e $file);
    my @lines = qx(cat $file);

    $self->assert_equals(4, scalar(@lines));
    @lines = sort(@lines);
    chomp(@lines);
    $self->assert_equals('ab,c,1', $lines[1]);
    $self->assert_equals('bc,[COMMA],1', $lines[2]);
    $self->assert_equals('c[COMMA],a,1', $lines[3]);
    $self->assert_equals('[COMMA]a,b,1', $lines[0]);

    



}



1;
