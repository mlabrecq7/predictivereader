package ML::Encoder::Score;

use strict;
use warnings;

sub new {
    my ($class) = @_;

    my $this;
    $this->{name} = 'me';
    bless($this, $class);
    return $this;

    
}

sub match {
    my ($this, $data) = @_;

    open(my $FILE, '<', $data->{source});
    my @lines = <$FILE>;
    chomp(@lines);
    my @comparelines = split("\n", $data->{compare});

    if (scalar(@lines) < scalar(@comparelines)) {
	my @hold = @lines;
	@lines = @comparelines;
	@comparelines = @hold;
    }
    my $increment = scalar(@comparelines);

    $increment = 100/$increment;
    
    my $score = 100;
    
    for my $index (0 .. (scalar(@comparelines) -1)) {
	if ($comparelines[$index] ne $lines[$index]) {
	    $score -= $increment
	}

    }
    
    return $score;

    

}


1;
