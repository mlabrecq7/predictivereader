package ML::Encoder::Reader;
use strict;
use warnings;

sub new {
    my ($class, $data) = @_;

    my $this;
    my %hash;
    $this->{data} = \%hash; 
    bless($this, $class);

    if(defined($data->{readDataFrom})) {
	$this->_loadData($data->{readDataFrom});
    }
    $this->{saveLocation} = $data->{saveDataTo};


    my @array;
    $this->{sizes} = @array;
    $this->{dirty} = 1;
    
    return $this;

    
}

sub _loadData {
    my ($this, $data) = @_;
    $this->{dirty} = 1;
    open(my $FILE, '<', $data) or die "$data not openable $!\n";
    
    for my $line (<$FILE>) {
	chomp($line);
	
	my @parts = split(',', $line);
	my $main = shift(@parts);
	if (!defined($main)) {
	    next;
	}
	$main =~ s/\[COMMA\]/,/g;

	if (!defined($this->{data}->{$main})) {
	    my %hash;
	    $this->{data}->{$main} = \%hash;
	    
	}
	while(my $key = shift(@parts)) {

	    if ($key eq '[COMMA]'){
		$key = ',';
	    }

	    if (!defined($this->{data}->{$main}->{$key})) {
		
		$this->{data}->{$main}->{$key} = 0;
	    }
	    my $value = shift(@parts);
	    
	    $this->{data}->{$main}->{$key} += $value;
	}

	
    }

}

sub encodeString {
    my ($this, $string, $size) = @_;
    $this->{dirty} = 1;
    $string =~ s/\n/ /g;
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

    if(defined($this->{saveLocation})) {
	$this->_saveData($this->{saveLocation});

    }
    
}

sub _saveData {
    my ($this, $savefile) = @_;

    open(my $FILE, '>', $savefile);
    for my $key (keys(%{$this->{data}})) {
	my $hash = $this->{data}->{$key};
	my $display = $key;
	$display =~ s/,/[COMMA]/g;
	my $string = "$display";
	for my $next (keys(%$hash)) {
	    my $value = $hash->{$next};
	    if ($next eq ',') {
		$next = '[COMMA]';
	    }
	    $string .= ",$next," . $value ;
	}
	$string .= "\n";
	print $FILE $string;
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
    my @choices;
    for my $entry (@entries) {
	
	my $char = $this->_getNextChar($entry);
	
	if (!defined($options{$char})) {
	    $options{$char} = 0;

	}
	push(@choices, $char);
	$options{$char}++;

    }
    my $char = $choices[rand @choices];
    
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
    if ($this->{dirty}) {
    
	my @options = keys(%{$this->{data}});
	
	my %sizes;
	
	for my $key (@options) {
	    $sizes{length($key)} = 1;
	}

	
	my @array =  keys(%sizes);
	$this->{dirty} = 0;
	$this->{sizes} = \@array;
    }

    return @{$this->{sizes}}
		       
    
}



1;
