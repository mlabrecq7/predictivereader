package ML::Encoder::Reader;
use strict;
use warnings;

sub new {
    my ($class) = @_;

    my $this;
    my %hash;
    $this->{data} = \%hash; 
    bless($this, $class);
    return $this;

}

sub encodeString {
    my ($this, $string, $size) = @_;

    
    my $length = (length $string) -1;
    for my $i (0 .. $length) {
	
	my $entry;
	my $next;
	if ($i + $size > $length + 1) {
	    my $tempstr = $string . substr($string, 0, $size);
	    $entry = substr($tempstr, $i, $size);
	    $next = substr($tempstr, $i + $size, 1);

	}
	elsif ($i + $size == $length + 1) {
	    $entry = substr($string, $i, $size);
	    $next = substr($string, 0, 1);

	}
	else {
	    $entry = substr($string, $i, $size);
	    $next = substr($string, $i + $size, 1);

	    
	}
	if (!defined($this->{data}->{$entry})) {
	    my %hash;
	    $this->{data}->{$entry} = \%hash;
	}
	if (!defined($this->{data}->{$entry}->{$next})) {
	    my %hash;
	    $this->{data}->{$entry}->{$next} = 0;

	}
	$this->{data}->{$entry}->{$next}++;
	
    }
    
}

sub getNextChar {
    my ($this, $entry) = @_;
    
    my @sizes = $this->_findKeySizes();

    my @entries;
    for my $size (@sizes) {

	if (length($entry) <= $size) {
	    push(@entries, $entry);
	    next;
	}
	my $smaller = substr($entry, -$size);

	push(@entries, $smaller);
    }

    my %options;

    for my $entry (@entries) {
	my $char = $this->_getNextChar($entry);
	if (!defined($options{$char})) {
	    $options{$char} = 0;

	}
	$options{$char}++;

    }
    
    
    my $char = '';
    my $max = 0;

    for my $key (keys(%options)) {
	my $value = $options{$key};
	if ($value > $max){
	    $char = $key;
	    $max = $value;
	}

    }

    return $char;
    
}


sub _getNextChar {
    my ($this, $entry) = @_;



    my $char = '';
    my $max = 0;
    
    my @options = keys(%{$this->{data}->{$entry}});
    
    for my $key (@options) {
	my $value = $this->{data}->{$entry}->{$key};
	if ($value > $max){
	    $char = $key;
	    $max = $value;
	}


    }

    return $char;
    
}

sub _findKeySizes {
    my ($this) = @_;
    my @options = keys(%{$this->{data}});

    my %sizes;

    for my $key (@options) {
	$sizes{length($key)} = 1;
    }

    return keys(%sizes);
    

		       
    
}



1;
