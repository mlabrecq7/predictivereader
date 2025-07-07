package ML::Encoder::Writer;
use strict;
use warnings;


sub new {
    my ($class, $reader) = @_;

    my $this;
    $this->{reader} = $reader;

    bless($this, $class);
    return $this;

}


sub startingFrom {
    my ($this, $key, $targetLength) = @_;

    my $output = $key;
    my $count = 0;
    while(length($output) < $targetLength + length($key)) {
	$output .= $this->{reader}->getNextChar($output);
	$count++;

	if ($count == 200) {
	    return $output;

	}
    }


    
    return $output
    
    


}

1;
