package ML::Test::Encoder::Response_script;
use strict;
use warnings;

use FindBin;
use File::Temp;

use base qw(Test::Unit::TestCase);

sub test_script {
    my ($self) = @_;

    my $scriptPath = "$FindBin::Bin/bin/response";

    my $cmd = "$scriptPath -input \"use str\" -length 4 -livefile " . __FILE__;

    my @output = qx($cmd);
    chomp(@output);
    
    $self->assert_equals('use str\" -', $output[0]);



}

sub test_save_data_on_fresh_directory {
    my ($self) = @_;

    my $scriptPath = "$FindBin::Bin/bin/response";
    my $dir = File::Temp->newdir(); # CLEANUP => 1 by default

    my $dataPath = "$dir/savedData";
    qx(mkdir $dataPath);

    
    my $cmd = "$scriptPath -input \"use str\" -length 4 -saveLocation $dataPath/lamo -livefile " . __FILE__;

    $self->assert_equals(1, !-e "$dataPath/lamo");
    
    my @output = qx($cmd);
    $self->assert_equals(1, -e "$dataPath/lamo");

}

sub test_recover_fake_data {

    my ($self) = @_;

    my $scriptPath = "$FindBin::Bin/bin/response";
    my $dir = File::Temp->newdir(); # CLEANUP => 1 by default

    my $dataPath = "$dir/savedData";
    qx(mkdir $dataPath);
    open(my $FILE, '>', "$dataPath/perl");
    print $FILE "us,e,400,r,1\n";
    print $FILE "se, ,400,r,1\n";
    print $FILE "e ,s,400,r,1\n";
    print $FILE " s,t,400,r,1\n";
    print $FILE "st,r,400,x,1\n";
    print $FILE "tr,i,400,r,1\n";
    print $FILE "ri,c,400,r,1\n";
    print $FILE "ic,t,400,r,1\n";
    print $FILE "ct,;,400,r,1\n";
    close($FILE);
    
    my $cmd = "$scriptPath -input \"use str\" -length 4 -savedData $dataPath/perl";

    my @output = qx($cmd);
    chomp(@output);
    
    $self->assert_equals('use strict;', $output[0]);


}


sub test_recover_earlier_data {

    my ($self) = @_;

    my $scriptPath = "$FindBin::Bin/bin/response";
    my $dir = File::Temp->newdir(); # CLEANUP => 1 by default

    my $dataPath = "$dir/savedData";
    qx(mkdir $dataPath);

    my $cmd = "$scriptPath -input \"use str\" -length 4 -saveLocation $dataPath/lamo -livefile " . __FILE__;

    my @output = qx($cmd);

    $cmd = "$scriptPath -input \"use str\" -length 4 -savedData $dataPath/lamo";

    @output = qx($cmd);
    chomp(@output);
    
    $self->assert_equals('use str\" -', $output[0]);


}

1;
