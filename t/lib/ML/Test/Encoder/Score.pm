package ML::Test::Encoder::Score;
use strict;
use warnings;

use File::Temp;

use ML::Encoder::Score;

use base qw(Test::Unit::TestCase);

sub test_score_zero {
    my ($self) = @_;

    my $dir = File::Temp->newdir();
    open(my $FILE, '>', "$dir/truth");
    print $FILE "I am the ultimate Truth speaking to Power\nOr so i said";
    close($FILE);
    
    my $args = {
	source => "$dir/truth",
	compare => "No way did you just see that",

    };
    my $scorer = ML::Encoder::Score->new();

    my $score = $scorer->match($args);

    $self->assert_equals(0, $score);
    

}


sub test_score_100 {
    my ($self) = @_;

    my $dir = File::Temp->newdir();
    open(my $FILE, '>', "$dir/truth");
    print $FILE "I am the ultimate Truth speaking to Power\nOr so i said";
    close($FILE);
    
    my $args = {
	source => "$dir/truth",
	compare => "I am the ultimate Truth speaking to Power\nOr so i said",

    };
    my $scorer = ML::Encoder::Score->new();

    my $score = $scorer->match($args);

    $self->assert_equals(100, $score);
    

}


sub test_score_50 {
    my ($self) = @_;

    my $dir = File::Temp->newdir();
    open(my $FILE, '>', "$dir/truth");
    print $FILE "I am the ultimate Truth speaking to Power\nOr so i said";
    close($FILE);
    
    my $args = {
	source => "$dir/truth",
	compare => "I am the ultimate Truth speaking to Power\nOr so I said",

    };
    my $scorer = ML::Encoder::Score->new();

    my $score = $scorer->match($args);

    $self->assert_equals(50, $score);
    

}



sub disabled_test_score_100_offset {
    my ($self) = @_;

    #this score thing is not smart yet.
    #not sure why I put it in.
    #i'm certainly not using it yet. 
    
    my $dir = File::Temp->newdir();
    open(my $FILE, '>', "$dir/truth");
    print $FILE "foo\nI am the ultimate Truth speaking to Power\nOr so i said";
    close($FILE);
    
    my $args = {
	source => "$dir/truth",
	compare => "I am the ultimate Truth speaking to Power\nOr so I said",

    };
    my $scorer = ML::Encoder::Score->new();

    my $score = $scorer->match($args);

    $self->assert_equals(100, $score);
    

}
1;
    
