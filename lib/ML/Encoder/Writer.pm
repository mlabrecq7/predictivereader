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

sub _recurseTillDone {
    my ($this, $soFar, $targetLength) = @_;

    if (length($soFar) == $targetLength) {
	return $soFar;
    }

    $soFar .= $this->{reader}->getNextChar($soFar);
    return $this->_recurseTillDone($soFar, $targetLength);


}

sub startingFrom {
    my ($this, $key, $targetLength) = @_;

    return $this->_recurseTillDone($key, length($key) + $targetLength);
    
    


}

1;
